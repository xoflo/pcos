import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/auth/signin.dart';
import 'package:thepcosprotocol_app/widgets/auth/goto_register.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/pcos_protocol.png'),
              ),
              SignIn(),
              GotoRegister(),
            ],
          ),
        ),
      ),
    );
  }
}
