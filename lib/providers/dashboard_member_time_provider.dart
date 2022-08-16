import 'package:flutter/material.dart';
import 'dart:async';

class DashboardMemberTimeProvider extends ChangeNotifier {
  String _asset = 'assets/morning.png';
  String get asset => _asset;

  Timer? timer;

  void initializeTimer() {
    timer = Timer.periodic(
        Duration(minutes: 1), (_) => updateDayNightBackground());
  }

  void updateDayNightBackground() {
    final hourNow = DateTime.now().hour;
    // If the time is from 6:00PM to 6:00AM, then the background screen
    // should be night time. If the hour is from 6:00AM to 12:00PM,
    // then the background should be morning time. Otherwise, the
    // default is a day screen.
    if (hourNow > 16 || hourNow < 6) {
      _asset = 'assets/night.png';
    } else if (hourNow >= 6 && hourNow < 11) {
      _asset = 'assets/morning.png';
    } else {
      _asset = 'assets/day.png';
    }
    notifyListeners();
  }
}
