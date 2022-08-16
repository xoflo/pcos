import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/providers/dashboard_member_time_provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/providers/preferences_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class DashboardMemberTime extends StatelessWidget {
  const DashboardMemberTime({
    Key? key,
  }) : super(key: key);

  // final MemberProvider memberProvider = Provider.of<MemberProvider>(context);
  // final bool isUsernameUsed;

  // Timer? timer;
  // final String asset = 'assets/morning.png';

  // @override
  // void initState() {
  //   super.initState();
  //   widget.memberProvider.populateMember();

  //   // Assign a day/night background the first time that the dashboard page is
  //   // presented
  //   _updateDayNightBackground();

  //   // Check day/night every minute. This applies as long as the user is in the
  //   // dashboard page
  //   timer = Timer.periodic(
  //       Duration(minutes: 1), (_) => _updateDayNightBackground());
  // }

  // void _updateDayNightBackground() {
  //   setState(() {
  //     final hourNow = DateTime.now().hour;
  //     // If the time is from 6:00PM to 6:00AM, then the background screen
  //     // should be night time. If the hour is from 6:00AM to 12:00PM,
  //     // then the background should be morning time. Otherwise, the
  //     // default is a day screen.
  //     if (hourNow > 16 || hourNow < 6) {
  //       asset = 'assets/night.png';
  //     } else if (hourNow >= 6 && hourNow < 11) {
  //       asset = 'assets/morning.png';
  //     } else {
  //       asset = 'assets/day.png';
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer?.cancel();
  // }

  // String get displayedName => widget.isUsernameUsed
  //     ? widget.memberProvider.alias
  //     : widget.memberProvider.firstName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          height: 150,
          child:
            //   ChangeNotifierProxyProvider<Timer, DashboardMemberTimeProvider>(
            // create: (context) => DashboardMemberTimeProvider(),
            // update: (context, timer, memberTimeProvider) {
            //   memberTimeProvider!.timer = Timer.periodic(
            //       Duration(minutes: 1),
            //       // ignore: unnecessary_null_comparison
            //       (_) => (memberTimeProvider != null)
            //           ? memberTimeProvider.updateDayNightBackground()
            //           : {});
            //   return memberTimeProvider;
            // },
            ChangeNotifierProvider<DashboardMemberTimeProvider>(
            create: (context) => DashboardMemberTimeProvider(),
            child: Consumer<DashboardMemberTimeProvider>(
              builder: (context, timeProvider, child) => FittedBox(
                child: Image.asset(timeProvider.asset),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // if (memberProvider.status == LoadingStatus.success)
        Padding(
            padding: EdgeInsets.all(15),
            child: Consumer<PreferencesProvider>(
              builder: (context, prefsProvider, child) => Text(
                "Hello " + prefsProvider.getPreferredDisplayName(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ))
        // else if (asset.isEmpty ||
        //     memberProvider.status == LoadingStatus.loading)
        //   PcosLoadingSpinner()
      ],
    );
  }
}
