import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/navigation/menu_left.dart';
import 'package:thepcosprotocol_app/screens/large/main_screens_large.dart';

class AppBodyLarge extends StatefulWidget {
  @override
  _AppBodyLargeState createState() => _AppBodyLargeState();
}

class _AppBodyLargeState extends State<AppBodyLarge> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: MenuLeft(
                currentIndex: _currentIndex,
                onTapped: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: MainScreensLarge(currentIndex: _currentIndex),
            ),
          ],
        ),
      ),
    );
  }
}
