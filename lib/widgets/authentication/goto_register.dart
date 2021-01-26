import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class GotoRegister extends StatelessWidget {
  final Function navigateToRegister;

  GotoRegister({this.navigateToRegister});

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
                S.of(context).signUpTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Text(
                  S.of(context).gotoSignupText,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                ),
                child: ColorButton(
                  isUpdating: false,
                  label: S.of(context).signUpTitle,
                  onTap: navigateToRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
