import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/custom_text_field.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class ProfilePersonalDetailsLayout extends StatefulWidget {
  const ProfilePersonalDetailsLayout({Key? key}) : super(key: key);

  @override
  State<ProfilePersonalDetailsLayout> createState() =>
      _ProfilePersonalDetailsLayoutState();
}

class _ProfilePersonalDetailsLayoutState
    extends State<ProfilePersonalDetailsLayout> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late MemberProvider memberProvider;

  @override
  void initState() {
    super.initState();
    memberProvider = Provider.of<MemberProvider>(context, listen: false);
  }

  List<Widget> _getChildren() {
    usernameController.text = memberProvider.alias;
    firstNameController.text = memberProvider.firstName;
    lastNameController.text = memberProvider.lastName;
    emailController.text = memberProvider.email;

    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Username",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: textColor.withOpacity(0.8),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 15),
                child: Text(
                  "@",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 48),
                child: TextFormField(
                  controller: usernameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textColor.withOpacity(0.8)),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textColor.withOpacity(0.8)),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textColor.withOpacity(0.8)),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: textColor.withOpacity(0.8)),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Please enter your new username";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 15),
      CustomTextField(
        controller: firstNameController,
        title: "First Name",
        blankMessageError: "Please input your first name",
      ),
      SizedBox(height: 15),
      CustomTextField(
        controller: lastNameController,
        title: "Last Name",
        blankMessageError: "Please input your last name",
      ),
      SizedBox(height: 15),
      CustomTextField(
        controller: emailController,
        title: "Email",
        isEnabled: false,
      ),
      FilledButton(
        text: "SAVE CHANGES",
        margin: EdgeInsets.symmetric(vertical: 25),
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();

          setState(() {});

          if (_formKey.currentState?.validate() == true) {
            analytics.logEvent(
              name: Analytics.ANALYTICS_EVENT_BUTTONCLICK,
              parameters: {
                Analytics.ANALYTICS_PARAMETER_BUTTON:
                    Analytics.ANALYTICS_BUTTON_SAVE_PROFILE
              },
            );
            if (memberProvider.alias != usernameController.text.trim()) {
              memberProvider.alias = usernameController.text.trim();
            }
            if (memberProvider.firstName != firstNameController.text.trim()) {
              memberProvider.firstName = firstNameController.text.trim();
            }
            if (memberProvider.lastName != lastNameController.text.trim()) {
              memberProvider.lastName = lastNameController.text.trim();
            }
          }

          try {
            final bool saveMember = await memberProvider.saveMemberDetails();

            if (saveMember) {
              Navigator.pop(context, true);
            }
          } catch (ex) {
            showAlertDialog(
              context,
              "Error",
              "Something went wrong. Please try again.",
              "",
              "Okay",
              null,
              null,
            );
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => LoaderOverlay(
        indicatorPosition: Alignment.center,
        loadingStatusNotifier: memberProvider,
        height: MediaQuery.of(context).size.height,
        child: WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    title: "Personal Details",
                    closeItem: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _getChildren(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
