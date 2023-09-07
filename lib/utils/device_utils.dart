import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info/package_info.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';

enum BuildMode { DEBUG, PROFILE, RELEASE }

class DeviceUtils {
  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;

    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }

  static Future<AndroidDeviceInfo> androidDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  static Future<IosDeviceInfo> iosDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }

  static bool isHorizontalWideScreen(final double width, final double height) {
    if (width > height && width > 700) {
      return true;
    }
    return false;
  }

  static int getItemsPerRow(double width, double height) {
    if (width > 700) {
      if (width > height) {
        return 3;
      } else {
        return 2;
      }
    }
    return 1;
  }

  static Future<bool> isVersionSupported() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String versionForChecker =
        version.substring(0, version.lastIndexOf("."));
    final String platformOS = Platform.isIOS ? "ios" : "android";
    return await WebServices().checkVersion(platformOS, versionForChecker);
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String versionForChecker =
        version.substring(0, version.lastIndexOf("."));

    return versionForChecker;
  }

  Future<Map<String, String>> getWebServiceHeaders() async {
    final appVersion = await DeviceUtils.getAppVersion();
    final majorVersion = appVersion.split(".")[0];
    final minorVersion = appVersion.split(".")[1];

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'X-APP-PLATFORM': Platform.isIOS ? "IOS" : "ANDROID",
      'X-APP-MAJOR-VERSION': majorVersion,
      'X-APP-MINOR-VERSION': minorVersion,
    };
  }
}
