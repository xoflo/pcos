import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_settings.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_read_only.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_editable.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/toggle_switch.dart';

class ProfileLayout extends StatefulWidget {
  @override
  _ProfileLayoutState createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  bool _isEditable = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLeftVisible = true;

  @override
  void initState() {
    super.initState();
    _getMemberDetails();
  }

  void _getMemberDetails() {
    Provider.of<MemberViewModel>(context, listen: false).populateMember();
  }

  void _editDetails(MemberViewModel? member) {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_BUTTON:
            Analytics.ANALYTICS_BUTTON_EDIT_PROFILE
      },
    );
    firstNameController.text = member?.firstName ?? "";
    lastNameController.text = member?.lastName ?? "";
    emailController.text = member?.email ?? "";
    setState(() {
      _isEditable = true;
    });
  }

  void _saveChanges(MemberViewModel member) {
    if (_formKey.currentState?.validate() == true) {
      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
        parameters: {
          Analytics.ANALYTICS_PARAMETER_BUTTON:
              Analytics.ANALYTICS_BUTTON_SAVE_PROFILE
        },
      );
      if (member.firstName != firstNameController.text.trim()) {
        member.firstName = firstNameController.text.trim();
      }
      if (member.lastName != lastNameController.text.trim()) {
        member.lastName = lastNameController.text.trim();
      }
      if (member.email != emailController.text.trim()) {
        member.email = emailController.text.trim();
      }
      Provider.of<MemberViewModel>(context, listen: false).saveMemberDetails();
      setState(() {
        _isEditable = false;
      });
    }
  }

  void _cancelChanges() {
    setState(() {
      _isEditable = false;
    });
  }

  Widget _memberDetails(Size screenSize, MemberViewModel vm) {
    switch (vm.status) {
      case LoadingStatus.loading:
        return Column(
          children: [
            Header(
              closeItem: () {
                Navigator.pop(context);
              },
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
      // return !_isEditable
      //     ? ProfileReadOnly(
      //         member: vm,
      //         screenSize: screenSize,
      //         editMemberDetails: _editDetails,
      //       )
      //     : Form(
      //         key: _formKey,
      //         child: ProfileEditable(
      //           member: vm,
      //           screenSize: screenSize,
      //           firstNameController: firstNameController,
      //           lastNameController: lastNameController,
      //           emailController: emailController,
      //           saveMemberDetails: _saveChanges,
      //           cancel: _cancelChanges,
      //         ),
      //       );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemberViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: _memberDetails(screenSize, vm),
    );
  }
}
