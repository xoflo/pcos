import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_layout.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: FavouritesLayout(),
        ),
      ),
    );
  }
}
