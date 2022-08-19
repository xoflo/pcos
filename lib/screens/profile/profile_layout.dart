import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_settings.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_summary.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/toggle_switch.dart';

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

  Widget _memberDetails(MemberProvider memberProvider) {
    final status = memberProvider.status;
    if (status == LoadingStatus.loading) {
      return LoaderOverlay();
    }

    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: "${memberProvider.firstName}'s Profile",
            closeItem: () => Navigator.pop(context),
          ),
          if (status == LoadingStatus.empty)
            NoResults(message: S.current.noMemberDetails)
          else ...[
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
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemberProvider>(context);

    return WillPopScope(
      onWillPop: () async => !Platform.isIOS,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: _memberDetails(vm),
      ),
    );
  }
}
