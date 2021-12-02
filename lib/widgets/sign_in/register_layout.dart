import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class RegisterLayout extends StatelessWidget {
  final Function navigateToRegister;
  final bool isHorizontal;

  RegisterLayout({
    @required this.navigateToRegister,
    @required this.isHorizontal,
  });

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
                S.current.signUpTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Text(
                  isHorizontal
                      ? S.current.openWebsiteText
                      : S.current.gotoSignupText,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                ),
                child: ColorButton(
                  isUpdating: false,
                  label: S.current.signUpTitle,
                  onTap: navigateToRegister,
                  width: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
