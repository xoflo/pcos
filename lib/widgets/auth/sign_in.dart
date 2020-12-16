import 'package:flutter/material.dart';

import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/other/spinner_button.dart';

class SignIn extends StatelessWidget {
  final bool isSigningIn;
  final Function() authenticateUser;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  SignIn({
    this.isSigningIn,
    this.authenticateUser,
    this.emailController,
    this.passwordController,
  });

  void attemptSignIn() async {
    authenticateUser();
  }

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
                S.of(context).signInTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).emailLabel,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).passwordLabel,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Container(
                  width: 150.0,
                  height: 40,
                  child: isSigningIn
                      ? SpinnerButton()
                      : OutlinedButton(
                          onPressed: () {
                            attemptSignIn();
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
    );
  }
}
