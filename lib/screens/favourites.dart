import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(S.of(context).favouritesTitle);
  }
}
