import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/favourites/favourites_layout.dart';

import '../../../styles/colors.dart';
import '../../../widgets/shared/header.dart';

class Favourites extends StatelessWidget {
  static const id = "favourites_page";

  @override
  Widget build(BuildContext context) {
    // This guarantees that the Favourtes will be loaded upon entry in this page
    // for the very first time that the user uses the app.
    Future(() async {
      await Provider.of<FavouritesProvider>(context, listen: false)
          .fetchAndSaveData();
    }).catchError((_) {});

    return Scaffold(
        backgroundColor: primaryColor,
        body: WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(
                  top: 12.0,
                ),
                child: Column(
                  children: [
                    Header(
                      title: 'Favorites',
                      closeItem: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: FavouritesLayout()
                    ),
                  ],
                )),
          ),
        ));
  }
}
