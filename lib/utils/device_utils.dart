import 'package:device_info/device_info.dart';

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

  static bool isHorizontalWideScreen(double width, double height) {
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
}
