import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/shared/custom_text_field.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

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

  @override
  void initState() {
    super.initState();
    Provider.of<MemberViewModel>(context, listen: false).populateMember();
  }

  List<Widget> _getChildren() {
    final vm = Provider.of<MemberViewModel>(context);

    switch (vm.status) {
      case LoadingStatus.loading:
        return [PcosLoadingSpinner()];
      case LoadingStatus.empty:
        return [NoResults(message: S.current.noMemberDetails)];
      case LoadingStatus.success:
        usernameController.text = vm.alias;
        firstNameController.text = vm.firstName;
        lastNameController.text = vm.lastName;
        emailController.text = vm.email;

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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 48),
                    child: TextFormField(
                      controller: usernameController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.normal),
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
                if (vm.alias != usernameController.text.trim()) {
                  vm.alias = usernameController.text.trim();
                }
                if (vm.firstName != firstNameController.text.trim()) {
                  vm.firstName = firstNameController.text.trim();
                }
                if (vm.lastName != lastNameController.text.trim()) {
                  vm.lastName = lastNameController.text.trim();
                }
                try {
                  final bool saveMember =
                      await Provider.of<MemberViewModel>(context, listen: false)
                          .saveMemberDetails();

                  if (saveMember) {
                    Navigator.pop(context, true);
                  }
                } catch (ex) {
                  showFlushBar(
                    context,
                    "Error",
                    "Something went wrong. Please try again",
                    backgroundColor: primaryColor,
                    borderColor: backgroundColor,
                    primaryColor: backgroundColor,
                  );
                }
              }
            },
          ),
        ];
    }
  }

  Widget _getComponent() => Column(
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
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: _getComponent(),
      );
}
