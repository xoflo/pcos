import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class YourWhySetting extends StatelessWidget {
  final bool isYourWhyOn;
  final bool hasYourWhyBeenEntered;
  final Function(bool) saveYourWhy;

  YourWhySetting(
      {@required this.isYourWhyOn,
      @required this.hasYourWhyBeenEntered,
      @required this.saveYourWhy});

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
                S.current.settingsYourWhyText,
                style: Theme.of(context).textTheme.headline5,
              ),
              Switch(
                value: isYourWhyOn,
                onChanged: (value) {
                  if (hasYourWhyBeenEntered) {
                    saveYourWhy(value);
                  } else {
                    showFlushBar(context, S.current.yourWhyWarningTitle,
                        S.current.yourWhyWarningText,
                        backgroundColor: Colors.white,
                        borderColor: primaryColorLight,
                        primaryColor: primaryColor);
                  }
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
