import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ChangePasswordLayout extends StatefulWidget {
  final Function closeMenuItem;

  ChangePasswordLayout({this.closeMenuItem});

  @override
  _ChangePasswordLayoutState createState() => _ChangePasswordLayoutState();
}

class _ChangePasswordLayoutState extends State<ChangePasswordLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            itemId: 0,
            favouriteType: FavouriteType.None,
            title: S.of(context).changePasswordTitle,
            isFavourite: false,
            closeItem: widget.closeMenuItem,
          ),
          Text("change password"),
        ],
      ),
    );
  }
}
