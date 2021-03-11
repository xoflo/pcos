import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class DiagonalBanner extends StatelessWidget {
  final String bannerText;

  DiagonalBanner({@required this.bannerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: bannerText,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: primaryColor,
        ),
      ),
    );
  }
}
