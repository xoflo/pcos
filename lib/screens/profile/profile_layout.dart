import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_settings.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_summary.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/toggle_switch.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class ProfileLayout extends StatefulWidget {
  @override
  _ProfileLayoutState createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  bool isLeftVisible = true;

  @override
  void initState() {
    super.initState();
    _getMemberDetails();
  }

  void _getMemberDetails() {
    Provider.of<MemberProvider>(context, listen: false).populateMember();
  }

  Widget _memberDetails(MemberProvider memberProvider) => Padding(
        padding: EdgeInsets.only(top: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              title: "${memberProvider.firstName}'s Profile",
              closeItem: () => Navigator.pop(context),
            ),
            ToggleSwitch(
              leftText: "Summary",
              rightText: "Settings",
              onTapLeft: () => setState(() => isLeftVisible = true),
              onTapRight: () => setState(() => isLeftVisible = false),
            ),
            if (isLeftVisible) ...[
              ProfileSummary(tags: memberProvider.member.typeTags ?? [])
            ] else
              ProfileSettings(
                email: memberProvider.email,
                onRefreshUserDetails: _getMemberDetails,
              )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberProvider>(
      builder: (context, memberProvider, child) {
        return LoaderOverlay(
          loadingStatusNotifier: memberProvider,
          indicatorPosition: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: WillPopScope(
            onWillPop: () async => !Platform.isIOS,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: _memberDetails(memberProvider),
            ),
          ),
        );
      },
    );
  }
}
