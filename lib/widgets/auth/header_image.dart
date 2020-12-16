import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class HeaderImage extends StatelessWidget {
  final Size screenSize;

  HeaderImage({this.screenSize});

  @override
  Widget build(BuildContext context) {
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
