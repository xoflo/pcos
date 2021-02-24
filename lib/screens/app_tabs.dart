import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/drawer_menu_item.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_unlock.dart';
import 'package:thepcosprotocol_app/screens/unsupported_version.dart';
import 'package:thepcosprotocol_app/widgets/navigation/drawer_menu.dart';
import 'package:thepcosprotocol_app/widgets/navigation/header_app_bar.dart';
import 'package:thepcosprotocol_app/widgets/navigation/app_navigation_tabs.dart';
import 'package:thepcosprotocol_app/widgets/app_body/main_screens.dart';
import 'package:thepcosprotocol_app/screens/menu/profile.dart';
import 'package:thepcosprotocol_app/screens/menu/settings.dart';
import 'package:thepcosprotocol_app/screens/menu/change_password.dart';
import 'package:thepcosprotocol_app/screens/menu/privacy.dart';
import 'package:thepcosprotocol_app/screens/menu/terms_and_conditions.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/widgets/test/flavor_banner.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial.dart';

class AppTabs extends StatefulWidget {
  static const String id = "app_tabs_screen";
  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool intercomInitialised = false;
  AppLifecycleState _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeIntercom();
  }

  @override
  void dispose() {
    debugPrint("*********APP TABS dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initializeIntercom() async {
    final List<String> intercomIds = FlavorConfig.instance.values.intercomIds;
    await Intercom.initialize(
      intercomIds[0],
      androidApiKey: intercomIds[1],
      iosApiKey: intercomIds[2],
    );
    if (!await AuthenticationController().getIntercomRegistered()) {
      final String userId = await AuthenticationController().getUserId();
      Intercom.registerIdentifiedUser(userId: userId);
      await AuthenticationController().saveIntercomRegistered();
    }
    setState(() {
      intercomInitialised = true;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("*****************didChangeAppLifecycleState $state");
    //backgrounded - app was active (resumed) and is now inactive
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
    debugPrint("*************APP OPENING");
    if (!await DeviceUtils.isVersionSupported()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          UnsupportedVersion.id, (Route<dynamic> route) => false);
    } else {
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final int backgroundedTimestamp =
          await AuthenticationController().getBackgroundedTimestamp();

      //check if app was backgrounded over five minutes (300,000 milliseconds) ago, and display lock screen if necessary
      final int lockoutSeconds = 5;

      if (backgroundedTimestamp != null &&
          currentTimestamp - backgroundedTimestamp > (lockoutSeconds * 1000)) {
        Navigator.pushNamed(
          context,
          PinUnlock.id,
          arguments: PinUnlockArguments(true),
        );
      }
    }
  }

  void openDrawerMenuItem(final DrawerMenuItem drawerMenuItem) {
    //close the drawer menu
    Navigator.pop(context);

    switch (drawerMenuItem) {
      case DrawerMenuItem.LOCK:
        Navigator.pushNamed(
          context,
          PinUnlock.id,
          arguments: PinUnlockArguments(true),
        );
        break;
      case DrawerMenuItem.SETTINGS:
        Navigator.pushNamed(context, Settings.id);
        break;
      case DrawerMenuItem.PROFILE:
        Navigator.pushNamed(context, Profile.id);
        break;
      case DrawerMenuItem.CHANGE_PASSWORD:
        Navigator.pushNamed(context, ChangePassword.id);
        break;
      case DrawerMenuItem.PRIVACY:
        Navigator.pushNamed(context, Privacy.id);
        break;
      case DrawerMenuItem.TERMS_OF_USE:
        Navigator.pushNamed(context, TermsAndConditions.id);
        break;
      case DrawerMenuItem.TUTORIAL:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Tutorial(
            closeTutorial: () {
              Navigator.pop(context);
            },
          ),
        );
        break;
    }
  }

  void openChat() {
    if (intercomInitialised) {
      Intercom.displayMessenger();
    } else {
      //TODO: Intercom didn't initialise, display a flushBar message
      debugPrint("handle if intercom didn't initialise");
    }
  }

  Future<bool> onBackPressed() {
    if (Platform.isIOS) return Future.value(false);

    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.of(context).areYouSureText,
                style: TextStyle(fontSize: 20)),
            content: new Text(S.of(context).exitAppText),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).noText,
                      style: TextStyle(fontSize: 24)),
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
                  child: Text(S.of(context).yesText,
                      style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        appBar: HeaderAppBar(
          currentIndex: _currentIndex,
          displayChat: openChat,
        ),
        drawer: DrawerMenu(
          openDrawerMenuItem: openDrawerMenuItem,
        ),
        body: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText1,
          child: Platform.isIOS
              ? MainScreens(
                  currentIndex: _currentIndex,
                )
              : WillPopScope(
                  onWillPop: () {
                    return onBackPressed();
                  },
                  child: MainScreens(
                    currentIndex: _currentIndex,
                  ),
                ),
        ),
        bottomNavigationBar: AppNavigationTabs(
          currentIndex: _currentIndex,
          onTapped: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
