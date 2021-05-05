import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class HeaderImage extends StatelessWidget {
  final Size screenSize;
  final bool isOrange;
  final double verticalTopPadding;

  HeaderImage({
    @required this.screenSize,
    @required this.isOrange,
    @required this.verticalTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    final String imagePath = isOrange
        ? 'assets/images/pcos_protocol_orange.png'
        : 'assets/images/pcos_protocol.png';

    if (DeviceUtils.isHorizontalWideScreen(
        screenSize.width, screenSize.height)) {
      //iPad horizontal
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image(
          image: AssetImage(imagePath),
          height: 80.0,
        ),
      );
    } else {
      //iPad vertical
      if (screenSize.width > 700) {
        //ipad vertical
        return Padding(
          padding: EdgeInsets.only(
            top: verticalTopPadding,
            bottom: 20,
          ),
          child: Image(
            image: AssetImage(imagePath),
            height: 80.0,
          ),
        );
      } else {
        //a mobile phone
        return Padding(
          padding: EdgeInsets.only(top: 15, bottom: 30.0),
          child: Image(
            image: AssetImage(imagePath),
            height: 65.0,
          ),
        );
      }
    }
  }
}
