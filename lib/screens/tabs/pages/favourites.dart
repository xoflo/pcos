import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/favourites/favourites_layout.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This guarantees that the Favourtes will be loaded upon entry in this page
    // for the very first time that the user uses the app.
    Future(() async {
      await Provider.of<FavouritesProvider>(context, listen: false)
          .fetchAndSaveData();
    }).catchError((_) {});

    return FavouritesLayout();
  }
}
