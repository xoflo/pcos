import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/tabs/dashboard.dart';
import 'package:thepcosprotocol_app/tabs/knowledge_base.dart';
import 'package:thepcosprotocol_app/tabs/recipes.dart';
import 'package:thepcosprotocol_app/tabs/favourites.dart';

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
