import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/cms_text_provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/providers/app_help_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_unlock.dart';
import 'package:thepcosprotocol_app/tabs/more_page.dart';
import 'package:thepcosprotocol_app/screens/unsupported_version.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/tabs/dashboard.dart';
import 'package:thepcosprotocol_app/tabs/favourites.dart';
import 'package:thepcosprotocol_app/tabs/recipes.dart';
import 'package:thepcosprotocol_app/widgets/navigation/app_navigation_tabs.dart';
import 'package:thepcosprotocol_app/screens/more/profile.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/widgets/test/flavor_banner.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';

class AppTabs extends StatefulWidget {
  final FirebaseAnalyticsObserver? observer;

  AppTabs({required this.observer});

  static const String id = "app_tabs_screen";
  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _intercomInitialised = false;
  late AppLifecycleState _appLifecycleState;
  bool _showYourWhy = false;
  bool _showLessonRecipes = false;
  bool _isLocked = false;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void initialize() async {
    tabController = TabController(initialIndex: 0, length: 5, vsync: this);

    //intercom
    final List<String> intercomIds = FlavorConfig.instance.values.intercomIds;
    await Intercom.initialize(
      intercomIds[0],
      androidApiKey: intercomIds[1],
      iosApiKey: intercomIds[2],
    );
    final String? userId = await AuthenticationController().getUserId();
    if (!await AuthenticationController().getIntercomRegistered()) {
      Intercom.registerIdentifiedUser(userId: userId);
      await AuthenticationController().saveIntercomRegistered();
    }

    //get the value for showYourWhy, and then pass down to the course screen
    final bool isYourWhyOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    final bool isLessonRecipesOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    final bool oneSignalDataSent = await PreferencesController()
        .getBool(SharedPreferencesKeys.ONE_SIGNAL_DATA_SENT);
    //register external userId and pcos_type (as tag) with OneSignal if not done before on this device
    if (!oneSignalDataSent) {
      await OneSignal.shared.setExternalUserId(userId ?? "");
      final String pcosType = await PreferencesController()
          .getString(SharedPreferencesKeys.PCOS_TYPE);
      await OneSignal.shared.sendTag("pcos_type", pcosType);
      await PreferencesController()
          .saveBool(SharedPreferencesKeys.ONE_SIGNAL_DATA_SENT, true);
    }

    setState(() {
      _intercomInitialised = true;
      _showYourWhy = isYourWhyOn;
      _showLessonRecipes = isLessonRecipesOn;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //backgrounded - app was active (resumed) and is now inactive
    _appLifecycleState = state;
    if (_appLifecycleState == AppLifecycleState.resumed &&
        state == AppLifecycleState.inactive) {
      AuthenticationController()
          .saveBackgroundedTimestamp(DateTime.now().millisecondsSinceEpoch);
    }

    //foregrounded - app was inactive and is now active (resumed)
    if ((_appLifecycleState == AppLifecycleState.inactive ||
            _appLifecycleState == AppLifecycleState.paused) &&
        state == AppLifecycleState.resumed) {
      appForegroundingCheck();
    }

    setState(() {
      _appLifecycleState = state;
    });
  }

// This function controls which screen the users sees when they foreground the app
  void appForegroundingCheck() async {
    if (!await DeviceUtils.isVersionSupported()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          UnsupportedVersion.id, (Route<dynamic> route) => false);
    } else if (!_isLocked) {
      //only lock if not already locked
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final int? backgroundedTimestamp =
          await AuthenticationController().getBackgroundedTimestamp();
      //check if app was backgrounded over five minutes (300 seconds) ago, and display lock screen if necessary
      final int lockoutSeconds = 300;
      if (backgroundedTimestamp != null &&
          currentTimestamp - backgroundedTimestamp > (lockoutSeconds * 1000)) {
        Navigator.pushNamed(
          context,
          PinUnlock.id,
          arguments: PinUnlockArguments(true, _setIsLocked),
        );
        _setIsLocked(true);
      }
    }
  }

  void _setIsLocked(final bool isLocked) {
    if (!isLocked) {
      //unlocking so force refresh modules data
      Provider.of<RecipesProvider>(context, listen: false).fetchAndSaveData();
      Provider.of<ModulesProvider>(context, listen: false)
          .fetchAndSaveData(true);
      Provider.of<AppHelpProvider>(context, listen: false).fetchAndSaveData();
      Provider.of<MessagesProvider>(context, listen: false).fetchAndSaveData();
      Provider.of<CMSTextProvider>(context, listen: false).fetchAndSaveData();
      Provider.of<FavouritesProvider>(context, listen: false)
          .fetchAndSaveData();
    }

    setState(() {
      _isLocked = isLocked;
    });
  }

  void openChat() {
    if (_intercomInitialised) {
      analytics.setCurrentScreen(
        screenName: Analytics.ANALYTICS_SCREEN_COACH_CHAT,
      );
      Intercom.displayMessenger();
    } else {
      //Intercom failed to initialise
      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_INTERCOM_INIT_FAILED,
      );

      showFlushBar(
        context,
        S.current.coachChatFailedTitle,
        S.current.coachChatFailedText,
        backgroundColor: Colors.white,
        borderColor: primaryColorLight,
        primaryColor: primaryColor,
      );
    }
  }

  Future<bool> onBackPressed() async {
    if (Platform.isIOS) return Future.value(false);

    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.current.areYouSureText,
                style: TextStyle(fontSize: 20)),
            content: new Text(S.current.exitAppText),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.noText, style: TextStyle(fontSize: 24)),
                ),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(S.current.yesText, style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _updateYourWhy(final bool isOn) {
    setState(() {
      _showYourWhy = isOn;
    });
  }

  bool get showAppBarItems => _currentIndex == 0 || _currentIndex == 4;

  @override
  Widget build(BuildContext context) => FlavorBanner(
        child: Scaffold(
          appBar: AppBar(
            leading: showAppBarItems
                ? IconButton(
                    icon: Icon(Icons.person_outline,
                        color: unselectedIndicatorIconColor),
                    onPressed: () => Navigator.pushNamed(context, Profile.id),
                  )
                : null,
            actions: showAppBarItems
                ? [
                    IconButton(
                      icon: Icon(
                        Icons.chat_outlined,
                        color: unselectedIndicatorColor,
                      ),
                      onPressed: openChat,
                    ),
                  ]
                : null,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          backgroundColor: primaryColor,
          body: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText1!,
            child: WillPopScope(
              onWillPop: onBackPressed,
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Dashboard(
                    showYourWhy: _showYourWhy,
                    showLessonRecipes: _showLessonRecipes,
                    updateYourWhy: _updateYourWhy,
                  ),
                  Center(
                    child: Text("Library"),
                  ),
                  Recipes(),
                  Favourites(),
                  MorePage(onLockApp: _setIsLocked),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppNavigationTabs(
            currentIndex: _currentIndex,
            tabController: tabController,
            onTapped: (index) => setState(() => _currentIndex = index),
            observer: widget.observer,
          ),
        ),
      );
}
