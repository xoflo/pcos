import 'package:flutter/material.dart';

import 'package:thepcosprotocol_app/styles/colors.dart';

import 'timeline_page.dart';
import 'people_page.dart';
import 'profile_page.dart';

/// Home page of the sample application.
///
/// Provides navigation to the rest of the app through a [PageView].
///
/// Pages:
/// - [TimelinePage] (default)
/// - [ProfilePage]
/// - [PeoplePage]
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          TimelinePage(),
          ProfilePage(),
          PeoplePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _pageController.jumpToPage(value);
          setState(() {
            _currentIndex = value;
          });
        },
        selectedItemColor: backgroundColor,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.timeline,
                color: backgroundColor,
              ),
              label: 'timeline'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: backgroundColor),
              label: 'profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people, color: backgroundColor),
              label: 'people'),
        ],
      ),
    );
  }
}
