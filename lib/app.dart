import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/cms_text_provider.dart';
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
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/providers/course_question_provider.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/global_vars.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final appTitle = "The PCOS Protocol";
  bool appError = false;
  GlobalVars refreshMessages = GlobalVars();

  FirebaseAnalyticsObserver observer;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  void initializeApp() async {
    initializeFlutterFire();
    initializeOneSignal();
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  //initialise Crashlytics for app
  Future<void> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
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

    //TODO: remove this temporary dbugging level
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      debugPrint(
          "*** RECEIVED PN - message=${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      //calling setState forces the app to get the data again so the messages refreshes, and the true in the refreshMessages global singleton means it comes from the API
      refreshMessages.setRefreshMessagesFromAPI(true);
      setState(() {});
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      debugPrint(
          "*** OPENED PN - message=${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    /*
    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      debugPrint(
          "*** CLICKED INAPP - message=${action.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      debugPrint("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      debugPrint("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      debugPrint(
          "EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });*/

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.init(FlavorConfig.instance.values.oneSignalAppID,
        iOSSettings: settings);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    //TODO: ask for permission on iOS somewhere else later
    //bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProxyProvider<DatabaseProvider, KnowledgeBaseProvider>(
          create: (context) => KnowledgeBaseProvider(dbProvider: null),
          update: (context, db, previous) =>
              KnowledgeBaseProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, FAQProvider>(
          create: (context) => FAQProvider(dbProvider: null),
          update: (context, db, previous) => FAQProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, CourseQuestionProvider>(
          create: (context) => CourseQuestionProvider(dbProvider: null),
          update: (context, db, previous) =>
              CourseQuestionProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, RecipesProvider>(
          create: (context) => RecipesProvider(dbProvider: null),
          update: (context, db, previous) => RecipesProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, FavouritesProvider>(
          create: (context) => FavouritesProvider(dbProvider: null),
          update: (context, db, previous) => FavouritesProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, MessagesProvider>(
          create: (context) => MessagesProvider(dbProvider: null),
          update: (context, db, previous) => MessagesProvider(dbProvider: db),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, CMSTextProvider>(
          create: (context) => CMSTextProvider(dbProvider: null),
          update: (context, db, previous) => CMSTextProvider(dbProvider: db),
        ),
      ],
      child: MaterialApp(
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
          SignIn.id: (context) => SignIn(),
          UnsupportedVersion.id: (context) => UnsupportedVersion(),
          PinUnlock.id: (context) => PinUnlock(),
          PinSet.id: (context) => PinSet(),
          AppTabs.id: (context) => AppTabs(observer: observer),
          Settings.id: (context) => Settings(),
          Profile.id: (context) => Profile(),
          ChangePassword.id: (context) => ChangePassword(),
          Privacy.id: (context) => Privacy(),
          TermsAndConditions.id: (context) => TermsAndConditions(),
          Messages.id: (context) => Messages(),
        },
        navigatorObservers: [
          observer,
        ],
      ),
    );
  }
}
