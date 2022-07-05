import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ProfileSettingsItem extends StatelessWidget {
  const ProfileSettingsItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding:
            EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 35),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: onTap,
      );
}
