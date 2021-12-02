import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class GotoSignIn extends StatelessWidget {
  final Function navigateToSignIn;

  GotoSignIn({this.navigateToSignIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: 30.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                S.current.gotoSigninText,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: ColorButton(
                  isUpdating: false,
                  label: S.current.returnToSignInTitle,
                  onTap: navigateToSignIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
