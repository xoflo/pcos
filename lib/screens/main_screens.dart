import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/dashboard.dart';
import 'package:thepcosprotocol_app/screens/knowledge_base.dart';
import 'package:thepcosprotocol_app/screens/recipes.dart';
import 'package:thepcosprotocol_app/screens/favourites.dart';

class MainScreens extends StatelessWidget {
  final int currentIndex;

  MainScreens({@required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        Dashboard(),
        KnowledgeBase(),
        Recipes(),
        Favourites(),
      ],
    );
  }
}
