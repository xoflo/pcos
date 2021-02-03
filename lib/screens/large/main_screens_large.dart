import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/dashboard.dart';
import 'package:thepcosprotocol_app/screens/knowledge_base.dart';
import 'package:thepcosprotocol_app/screens/recipes.dart';
import 'package:thepcosprotocol_app/screens/coach_chat.dart';

class MainScreensLarge extends StatelessWidget {
  final int currentIndex;

  MainScreensLarge({@required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        Dashboard(),
        KnowledgeBase(),
        Recipes(),
        CoachChat(),
        Text("Profile"),
        Text("Change Password"),
        Text("Request Data"),
        Text("Help"),
        Text("Support"),
        Text("Privacy"),
        Text("Terms of Use"),
      ],
    );
  }
}
