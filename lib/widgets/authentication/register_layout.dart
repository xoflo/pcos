import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/authentication/header_image.dart';

class RegisterLayout extends StatelessWidget {
  final bool isHorizontal;
  final Size screenSize;
  final Widget openSignUp;
  final Widget emailSignUp;
  final Widget gotoSignIn;

  RegisterLayout(
      {this.isHorizontal,
      this.screenSize,
      this.openSignUp,
      this.emailSignUp,
      this.gotoSignIn});

  @override
  Widget build(BuildContext context) {
    final double boxWidth = screenSize.width * 0.33;
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
                    height: 230.0,
                    width: boxWidth,
                    child: openSignUp,
                  ),
                  /*SizedBox(
                    height: 230.0,
                    width: boxWidth,
                    child: emailSignUp,
                  ),*/
                  SizedBox(
                    height: 230.0,
                    width: boxWidth,
                    child: gotoSignIn,
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
              SizedBox(
                height: 270,
                child: openSignUp,
              ),
              /*SizedBox(
                height: 270,
                child: emailSignUp,
              ),*/
              SizedBox(
                height: 160,
                child: gotoSignIn,
              ),
            ],
          );
  }
}
