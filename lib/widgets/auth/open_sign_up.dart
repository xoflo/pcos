import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class OpenSignUp extends StatelessWidget {
  final Function openWebsite;

  OpenSignUp({this.openWebsite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: 30.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).openWebsiteText,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Container(
                  width: 150.0,
                  height: 40.0,
                  child: OutlinedButton(
                    onPressed: () {
                      openWebsite();
                    },
                    child: Text(
                      S.of(context).openWebsiteTitle,
                      style: TextStyle(
                        color: primaryColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
