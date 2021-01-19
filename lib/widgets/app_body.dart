import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/drawer_menu_item.dart';
import 'package:thepcosprotocol_app/widgets/navigation/drawer_menu.dart';
import 'package:thepcosprotocol_app/widgets/navigation/header_app_bar.dart';
import 'package:thepcosprotocol_app/widgets/navigation/app_navigation_tabs.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/screens/main_screens.dart';
import 'package:thepcosprotocol_app/screens/help.dart';
import 'package:thepcosprotocol_app/screens/privacy.dart';
import 'package:thepcosprotocol_app/screens/terms_and_conditions.dart';

class AppBody extends StatefulWidget {
  final Function(AppState) updateAppState;

  AppBody({this.updateAppState});

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  int _currentIndex = 0;

  void updateAppState(final AppState appState) {
    widget.updateAppState(appState);
  }

  void openDrawerMenuItem(final DrawerMenuItem drawerMenuItem) {
    Navigator.pop(context);

    switch (drawerMenuItem) {
      case DrawerMenuItem.PROFILE:
        debugPrint("Profile");
        break;
      case DrawerMenuItem.CHANGE_PASSWORD:
        debugPrint("Change Password");
        break;
      case DrawerMenuItem.REQUEST_DATA:
        debugPrint("Request data");
        break;
      case DrawerMenuItem.HELP:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Help(
              closeMenuItem: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        break;
      case DrawerMenuItem.SUPPORT:
        debugPrint("Support");
        break;
      case DrawerMenuItem.PRIVACY:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Privacy(
              closeMenuItem: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        break;
      case DrawerMenuItem.TERMS_OF_USE:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TermsAndConditions(
              closeMenuItem: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        break;
    }
  }

  void closeMenuItem() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderAppBar(currentIndex: _currentIndex),
      drawer: DrawerMenu(
        updateAppState: updateAppState,
        openDrawerMenuItem: openDrawerMenuItem,
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1,
        child: MainScreens(
          currentIndex: _currentIndex,
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
    );
  }
}
