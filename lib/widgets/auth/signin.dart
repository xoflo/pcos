import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).signInTitle,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: S.of(context).emailLabel,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
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
                        child: OutlinedButton(
                          onPressed: () {
                            debugPrint("sign in");
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
        ],
      ),
    );
  }
}
