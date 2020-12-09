import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/navigation/drawer_menu.dart';
import 'package:thepcosprotocol_app/widgets/navigation/header_app_bar.dart';
import 'package:thepcosprotocol_app/widgets/navigation/app_navigation_bar.dart';
import 'package:thepcosprotocol_app/screens/main_screens.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderAppBar(currentIndex: _currentIndex),
      drawer: DrawerMenu(),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1,
        child: MainScreens(
          currentIndex: _currentIndex,
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
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
