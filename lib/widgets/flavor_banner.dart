import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/widgets/device_info_dialog.dart';

class FlavorBanner extends StatelessWidget {

  final Widget child;
  BannerConfig bannerConfig;

  FlavorBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    if(FlavorConfig.isProd()) return child;

    bannerConfig ??= _getDefaultBanner();

    return Stack(
      children: <Widget>[
        child,
        _buildBanner(context)
      ],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
        bannerName: FlavorConfig.instance.name,
        bannerColor: FlavorConfig.instance.color
    );
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 50,
        height: 50,
        child: CustomPaint(
          painter: BannerPainter(
              message: bannerConfig.bannerName,
              textDirection: Directionality.of(context),
              layoutDirection: Directionality.of(context),
              location: BannerLocation.topStart,
              color: bannerConfig.bannerColor
          ),
        ),
      ),
      onLongPress: () {
        showDialog(context: context, builder: (BuildContext context) {
          return DeviceInfoDialog();
        });
      },
    );
  }
}

class BannerConfig {

  final String bannerName;
  final Color bannerColor;

  BannerConfig({
    @required String this.bannerName,
    @required Color this.bannerColor});

}