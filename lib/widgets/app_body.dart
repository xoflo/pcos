import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/navigation/drawer_menu.dart';
import 'package:thepcosprotocol_app/widgets/navigation/header_app_bar.dart';
import 'package:thepcosprotocol_app/widgets/navigation/app_navigation_tabs.dart';
import 'package:thepcosprotocol_app/screens/main_screens.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderAppBar(currentIndex: _currentIndex),
      drawer: DrawerMenu(updateAppState: updateAppState),
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
