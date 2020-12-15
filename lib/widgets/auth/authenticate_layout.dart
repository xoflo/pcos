import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

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
              getHeaderImage(screenSize),
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
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getHeaderImage(screenSize),
              signIn,
              SizedBox(
                height: 250,
                child: gotoRegister,
              ),
            ],
          );
  }

  Widget getHeaderImage(Size screenSize) {
    if (DeviceUtils.isHorizontalWideScreen(
        screenSize.width, screenSize.height)) {
      //iPad horizontal
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Image(
          image: AssetImage('assets/images/pcos_protocol.png'),
          height: 100.0,
        ),
      );
    } else {
      //vertical
      if (screenSize.width > 700) {
        //ipad vertical
        return Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Image(
            image: AssetImage('assets/images/pcos_protocol.png'),
            height: 120.0,
          ),
        );
      } else {
        //a phone
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Image(
            image: AssetImage('assets/images/pcos_protocol.png'),
          ),
        );
      }
    }
  }
}
