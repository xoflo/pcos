import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/auth/header_image.dart';

class AuthenticateLayout extends StatelessWidget {
  final bool isHorizontal;
  final Size screenSize;
  final Widget signIn;
  final Widget gotoRegister;

  AuthenticateLayout(
      {this.isHorizontal, this.screenSize, this.signIn, this.gotoRegister});

  @override
  Widget build(BuildContext context) {
    final double boxWidth = screenSize.width * 0.4;
    return isHorizontal
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderImage(screenSize: screenSize),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 330.0,
                    width: boxWidth,
                    child: signIn,
                  ),
                  SizedBox(
                    height: 330.0,
                    width: boxWidth,
                    child: gotoRegister,
                  ),
                ],
              ),
            ],
          )
        : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              HeaderImage(screenSize: screenSize),
              signIn,
              SizedBox(
                height: 250,
                child: gotoRegister,
              ),
            ],
          );
  }
}
