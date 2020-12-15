import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class Register extends StatelessWidget {
  final Function(AppState) updateAppState;

  Register({this.updateAppState});

  void navigateToSignIn() {
    debugPrint("signin");
    updateAppState(AppState.SIGNIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SafeArea(
        child: Padding(
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
                      S.of(context).goto_signup_text,
                      textAlign: TextAlign.center,
                    ),
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
                          navigateToSignIn();
                        },
                        child: Text(
                          S.of(context).signInTitle,
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
        ),
      ),
    );
  }
}
