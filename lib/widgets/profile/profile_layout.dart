import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_settings.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
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
    Provider.of<MemberViewModel>(context, listen: false).populateMember();
  }

  Widget _memberDetails(Size screenSize, MemberViewModel vm) {
    switch (vm.status) {
      case LoadingStatus.loading:
        return Column(
          children: [
            Header(
              closeItem: () => Navigator.pop(context),
            ),
            PcosLoadingSpinner(),
          ],
        );
      case LoadingStatus.empty:
        return NoResults(message: S.current.noMemberDetails);
      case LoadingStatus.success:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              title: "${vm.firstName}'s Profile",
              closeItem: () => Navigator.pop(context),
            ),
            ToggleSwitch(
              leftText: "Summary",
              rightText: "Settings",
              onTapLeft: () => setState(() => isLeftVisible = true),
              onTapRight: () => setState(() => isLeftVisible = false),
            ),
            if (isLeftVisible) Container() else ProfileSettings(email: vm.email)
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemberViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: _memberDetails(screenSize, vm),
    );
  }
}
