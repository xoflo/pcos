import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:thepcosprotocol_app/constants/drawer_menu_item.dart';
import 'package:thepcosprotocol_app/screens/messages.dart';
import 'package:thepcosprotocol_app/widgets/navigation/drawer_menu.dart';
import 'package:thepcosprotocol_app/widgets/navigation/header_app_bar.dart';
import 'package:thepcosprotocol_app/widgets/navigation/app_navigation_tabs.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/screens/main_screens.dart';
import 'package:thepcosprotocol_app/screens/profile.dart';
import 'package:thepcosprotocol_app/screens/change_password.dart';
import 'package:thepcosprotocol_app/screens/privacy.dart';
import 'package:thepcosprotocol_app/screens/terms_and_conditions.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/providers/course_question_provider.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class AppBody extends StatefulWidget {
  final Function(AppState) updateAppState;

  AppBody({this.updateAppState});

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  int _currentIndex = 0;
  bool intercomInitialised = false;

  @override
  void initState() {
    super.initState();
    initializeIntercom();
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

  void updateAppState(final AppState appState) {
    widget.updateAppState(appState);
  }

  void openDrawerMenuItem(final DrawerMenuItem drawerMenuItem) {
    Navigator.pop(context);

    switch (drawerMenuItem) {
      case DrawerMenuItem.PROFILE:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
              closeMenuItem: closeMenuItem,
            ),
          ),
        );
        break;
      case DrawerMenuItem.CHANGE_PASSWORD:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePassword(
              closeMenuItem: closeMenuItem,
            ),
          ),
        );
        break;
      case DrawerMenuItem.PRIVACY:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Privacy(
              closeMenuItem: closeMenuItem,
            ),
          ),
        );
        break;
      case DrawerMenuItem.TERMS_OF_USE:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TermsAndConditions(
              closeMenuItem: closeMenuItem,
            ),
          ),
        );
        break;
    }
  }

  void closeMenuItem() {
    Navigator.pop(context);
  }

  void openChat() {
    if (intercomInitialised) {
      Intercom.displayMessenger();
    } else {
      //TODO: Intercom didn't initialise
      debugPrint("handle if intercom didn't initialise");
    }
  }

  void openNotifications(final MessagesProvider messagesProvider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Messages(
          messagesProvider: messagesProvider,
          closeMenuItem: closeMenuItem,
        ),
      ),
    );
  }

  Future<bool> onBackPressed() {
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
                onTap: () => Navigator.of(context).pop(true),
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

  /*
  void openHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Help(
          closeMenuItem: closeHelp,
        ),
      ),
    );
  }

  void closeHelp() {
    Navigator.pop(context);
  }
  */

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
      ],
      child: Scaffold(
        appBar: HeaderAppBar(
          currentIndex: _currentIndex,
          displayChat: openChat,
          displayNotifications: openNotifications,
        ),
        drawer: DrawerMenu(
          updateAppState: updateAppState,
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
        /*floatingActionButton: _currentIndex == 8
            ? Container(
                width: 40,
                height: 40,
                child: FittedBox(
                  child: FloatingActionButton(
                    heroTag: 'openHelpFab',
                    child: Text(
                      "?",
                      style: TextStyle(fontSize: 36),
                    ),
                    backgroundColor: primaryColorDark,
                    onPressed: () {
                      openHelp(context);
                    },
                  ),
                ),
              )
            : Container(),*/
      ),
    );
  }
}
