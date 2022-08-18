import 'package:flutter/material.dart';

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
            EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 35),
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: onTap,
      );
}
