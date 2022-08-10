import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class DashboardMemberTime extends StatefulWidget {
  const DashboardMemberTime({
    Key? key,
    required this.memberProvider,
    required this.isUsernameUsed,
  }) : super(key: key);

  final MemberProvider memberProvider;
  final bool isUsernameUsed;

  @override
  State<DashboardMemberTime> createState() => _DashboardMemberTimeState();
}

class _DashboardMemberTimeState extends State<DashboardMemberTime> {
  Timer? timer;
  String asset = '';

  @override
  void initState() {
    super.initState();
    widget.memberProvider.populateMember();

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

  String get displayedName => widget.isUsernameUsed
      ? widget.memberProvider.alias
      : widget.memberProvider.firstName;

  @override
  Widget build(BuildContext context) => Stack(
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
          if (widget.memberProvider.status == LoadingStatus.success)
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Hello ${widget.memberProvider.firstName}",
                style: Theme.of(context).textTheme.headline1,
              ),
            )
          else if (asset.isEmpty ||
              widget.memberProvider.status == LoadingStatus.loading)
            PcosLoadingSpinner()
        ],
      );
}
