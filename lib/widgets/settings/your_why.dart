import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class YourWhySetting extends StatelessWidget {
  final bool isYourWhyOn;
  final Function(bool) saveYourWhy;

  YourWhySetting({@required this.isYourWhyOn, @required this.saveYourWhy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).settingsYourWhyText,
                style: Theme.of(context).textTheme.headline5,
              ),
              Switch(
                value: isYourWhyOn,
                onChanged: (value) {
                  saveYourWhy(value);
                },
                activeTrackColor: secondaryColor,
                activeColor: secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
