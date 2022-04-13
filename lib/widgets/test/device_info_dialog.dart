import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/utils/string_utils.dart';

class DeviceInfoDialog extends StatelessWidget {
  DeviceInfoDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10.0),
      title: Container(
        padding: EdgeInsets.all(15.0),
        color: FlavorConfig.instance.color,
        child: Text(
          'Device Info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      titlePadding: EdgeInsets.all(0),
      content: _getContent(context),
    );
  }

  Widget _getContent(BuildContext context) {
    if (Platform.isAndroid) {
      return _androidContent();
    }

    if (Platform.isIOS) {
      return _iOSContent();
    }

    return Text(
        "You're not on Android or iOS, so we can't display your device info.");
  }

  Widget _iOSContent() {
    return FutureBuilder(
      future: DeviceUtils.iosDeviceInfo(),
      builder: (context, AsyncSnapshot<IosDeviceInfo> snapshot) {
        if (!snapshot.hasData) return Container();

        IosDeviceInfo? device = snapshot.data;
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTile('Flavor:', '${FlavorConfig.instance.name}'),
              _buildTile('Build mode:',
                  '${StringUtils.enumName(DeviceUtils.currentBuildMode().toString())}'),
              _buildTile('Physical device?:', '${device?.isPhysicalDevice}'),
              _buildTile('Device:', '${device?.name}'),
              _buildTile('Model:', '${device?.model}'),
              _buildTile('System name:', '${device?.systemName}'),
              _buildTile('System version:', '${device?.systemVersion}'),
              _getDimensions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _androidContent() {
    return FutureBuilder(
      future: DeviceUtils.androidDeviceInfo(),
      builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
        if (!snapshot.hasData) return Container();

        AndroidDeviceInfo? device = snapshot.data;
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTile('Flavor:', '${FlavorConfig.instance.name}'),
              _buildTile('Build mode:',
                  '${StringUtils.enumName(DeviceUtils.currentBuildMode().toString())}'),
              _buildTile('Physical device?:', '${device?.isPhysicalDevice}'),
              _buildTile('Manufacturer:', '${device?.manufacturer}'),
              _buildTile('Model:', '${device?.model}'),
              _buildTile('Android version:', '${device?.version.release}'),
              _buildTile('Android SDK:', '${device?.version.sdkInt}'),
              _getDimensions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _getDimensions(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return (_buildTile('Screen Size:',
        'W:${screenSize.width.toStringAsFixed(2)} H:${screenSize.height.toStringAsFixed(2)}'));
  }

  Widget _buildTile(String key, String value) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value)
        ],
      ),
    );
  }
}
