import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class DashboardMemberTime extends StatefulWidget {
  const DashboardMemberTime({Key? key, required this.memberViewModel})
      : super(key: key);

  final MemberViewModel memberViewModel;

  @override
  State<DashboardMemberTime> createState() => _DashboardMemberTimeState();
}

class _DashboardMemberTimeState extends State<DashboardMemberTime> {
  Timer? timer;
  String asset = '';
  @override
  void initState() {
    super.initState();
    widget.memberViewModel.populateMember();

    timer = Timer.periodic(Duration(seconds: 1), (_) {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Widget getItem() {
    switch (widget.memberViewModel.status) {
      case LoadingStatus.success:
        return Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Hello ${widget.memberViewModel.firstName}",
            style: TextStyle(
                color: textColor, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        );
      default:
        break;
    }
    return Container();
  }

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
          if (widget.memberViewModel.status == LoadingStatus.success)
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Hello ${widget.memberViewModel.firstName}",
                style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            )
          else if (asset.isEmpty ||
              widget.memberViewModel.status == LoadingStatus.loading)
            PcosLoadingSpinner()
        ],
      );
}
