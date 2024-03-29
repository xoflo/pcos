import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/providers/preferences_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class DashboardMemberTime extends StatefulWidget {
  const DashboardMemberTime({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardMemberTime> createState() => _DashboardMemberTimeState();
}

class _DashboardMemberTimeState extends State<DashboardMemberTime> {
  Timer? timer;
  String asset = '';

  @override
  void initState() {
    super.initState();

    // Assign a day/night background the first time that the dashboard page is
    // presented
    _updateDayNightBackground();

    // Check day/night every minute. This applies as long as the user is in the
    // dashboard page
    timer = Timer.periodic(
        Duration(minutes: 1), (_) => _updateDayNightBackground());
  }

  void _updateDayNightBackground() {
    setState(() {
      final hourNow = DateTime.now().hour;
      // If the time is from 6:00PM to 6:00AM, then the background screen
      // should be night time. If the hour is from 6:00AM to 12:00PM,
      // then the background should be morning time. Otherwise, the
      // default is a day screen.
      if (hourNow > 16 || hourNow < 6) {
        asset = 'assets/night.png';
      } else if (hourNow >= 6 && hourNow < 11) {
        asset = 'assets/morning.png';
      } else {
        asset = 'assets/day.png';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final preferencesProvider = Provider.of<PreferencesProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);
    return LoaderOverlay(
      loadingStatusNotifier: memberProvider,
      height: 150,
      indicatorPosition: Alignment.center,
      overlayBackgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: 150,
            child: asset.isNotEmpty
                ? FittedBox(
                    child: Image.asset(asset),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              preferencesProvider.preferredDisplayName,
              style: Theme.of(context).textTheme.headline1,
            ),
          )
        ],
      ),
    );
  }
}
