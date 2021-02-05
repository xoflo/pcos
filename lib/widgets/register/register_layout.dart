import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';

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
    final double boxWidth = screenSize.width * 0.40;
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
                    height: 240.0,
                    width: boxWidth,
                    child: openSignUp,
                  ),
                  /*SizedBox(
                    height: 230.0,
                    width: boxWidth,
                    child: emailSignUp,
                  ),*/
                  SizedBox(
                    height: 240.0,
                    width: boxWidth,
                    child: gotoSignIn,
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                HeaderImage(screenSize: screenSize),
                SizedBox(
                  height: 360,
                  child: openSignUp,
                ),
                /*SizedBox(
                  height: 270,
                  child: emailSignUp,
                ),*/
                SizedBox(
                  height: 170,
                  child: gotoSignIn,
                ),
              ],
            ),
          );
  }
}
