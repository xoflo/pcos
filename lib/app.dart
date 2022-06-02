import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:thepcosprotocol_app/screens/menu/app_help.dart';
import 'package:thepcosprotocol_app/screens/other/lesson_search.dart';
import 'package:thepcosprotocol_app/screens/other/previous_modules.dart';
import 'package:thepcosprotocol_app/screens/other/quiz.dart';
import 'package:thepcosprotocol_app/screens/other/wiki_search.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/header/messages.dart';
import 'package:thepcosprotocol_app/screens/menu/change_password.dart';
import 'package:thepcosprotocol_app/screens/menu/privacy.dart';
import 'package:thepcosprotocol_app/screens/menu/profile.dart';
import 'package:thepcosprotocol_app/screens/menu/terms_and_conditions.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_set.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_unlock.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/screens/unsupported_version.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/screens/app_loading.dart';
import 'package:thepcosprotocol_app/screens/menu/settings.dart';
import 'package:thepcosprotocol_app/styles/app_theme_data.dart';
import 'package:thepcosprotocol_app/providers/cms_text_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/app_help_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/global_vars.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/app_tutorial/app_tutorial_page.dart';
import 'package:thepcosprotocol_app/widgets/onboarding/onboarding_page.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_delete_page.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_personal_details.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/register_web_view.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final appTitle = "The PCOS Protocol";
  bool appError = false;
  GlobalVars refreshMessages = GlobalVars();

  FirebaseAnalyticsObserver? observer;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  void initializeApp() async {
    initializeFlutterFire();
    initializeOneSignal();
    setDeviceOrientations();
  }

  //initialise Crashlytics for app
  Future<void> initializeFlutterFire() async {
    try {
      Firebase.initializeApp().then((app) {
        FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);
        observer = FirebaseAnalyticsObserver(analytics: analytics);
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        appError = true;
      });
    }
  }

  // OneSignal initialisation - Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initializeOneSignal() async {
    if (!mounted) return;

    //temporary dbugging level
    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setNotificationWillShowInForegroundHandler((notification) {
      //calling setState forces the app to get the data again so the messages refreshes, and the true in the refreshMessages global singleton means it comes from the API
      refreshMessages.setRefreshMessagesFromAPI(true);
      setState(() {});
    });

    /*OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint(
          "*** OPENED PN - message=${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });*/

    await OneSignal.shared
        .setAppId(FlavorConfig.instance.values.oneSignalAppID);
  }

  void setDeviceOrientations() async {
    if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await DeviceUtils.iosDeviceInfo();
      if (!iosDeviceInfo.model.toLowerCase().contains("ipad")) {
        //this is iOS but not a iPad so DO NOT allow landscape mode all the time
        //this gets allowed when the video player goes full screen
        //and converts back after the video goes out of fullscreen mode
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProxyProvider<DatabaseProvider, RecipesProvider>(
          create: (context) => RecipesProvider(dbProvider: null),
          update: (context, db, previous) => RecipesProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, ModulesProvider>(
          create: (context) => ModulesProvider(dbProvider: null),
          update: (context, db, previous) => ModulesProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, AppHelpProvider>(
          create: (context) => AppHelpProvider(dbProvider: null),
          update: (context, db, previous) => AppHelpProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, MessagesProvider>(
          create: (context) => MessagesProvider(dbProvider: null),
          update: (context, db, previous) => MessagesProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, CMSTextProvider>(
          create: (context) => CMSTextProvider(dbProvider: null),
          update: (context, db, previous) => CMSTextProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, FavouritesProvider>(
          create: (context) => FavouritesProvider(dbProvider: null),
          update: (context, db, previous) => FavouritesProvider(dbProvider: db),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          S.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: appTitle,
        theme: appThemeData(),
        initialRoute: AppLoading.id,
        routes: {
          AppLoading.id: (context) => AppLoading(),
          AppTutorialPage.id: (context) => AppTutorialPage(),
          OnboardingPage.id: (context) => OnboardingPage(),
          SignIn.id: (context) => SignIn(),
          RegisterWebView.id: (context) => RegisterWebView(),
          UnsupportedVersion.id: (context) => UnsupportedVersion(),
          PinUnlock.id: (context) => PinUnlock(),
          PinSet.id: (context) => PinSet(),
          AppTabs.id: (context) => AppTabs(observer: observer),
          Settings.id: (context) => Settings(),
          Profile.id: (context) => Profile(),
          ChangePassword.id: (context) => ChangePassword(),
          AppHelp.id: (context) => AppHelp(),
          Privacy.id: (context) => Privacy(),
          TermsAndConditions.id: (context) => TermsAndConditions(),
          Messages.id: (context) => Messages(),
          PreviousModules.id: (context) => PreviousModules(),
          LessonSearch.id: (context) => LessonSearch(),
          WikiSearch.id: (context) => WikiSearch(),
          QuizScreen.id: (context) => QuizScreen(),
          ProfileDeletePage.id: (context) => ProfileDeletePage(),
          ProfilePersonalDetails.id: (context) => ProfilePersonalDetails(),
        },
        navigatorObservers:
            (observer == null) ? [] : <NavigatorObserver>[observer!],
      ),
    );
  }
}
