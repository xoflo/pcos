import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class HeaderImage extends StatelessWidget {
  final Size? screenSize;
  final bool isOrange;
  final double verticalTopPadding;

  HeaderImage({
    required this.screenSize,
    required this.isOrange,
    required this.verticalTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    final String imagePath =
        isOrange ? 'assets/logo_green.png' : 'assets/logo_white.png';

    if (DeviceUtils.isHorizontalWideScreen(
        screenSize?.width ?? 0, screenSize?.height ?? 0)) {
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
      if ((screenSize?.width ?? 0) > 700) {
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
        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            top: 50,
            bottom: 50,
            left: 25,
          ),
          child: Image(
            image: AssetImage(imagePath),
            height: 30,
          ),
        );
      }
    }
  }
}
