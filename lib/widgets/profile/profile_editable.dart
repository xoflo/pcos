import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class ProfileEditable extends StatelessWidget {
  final MemberViewModel member;
  final Size screenSize;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final Function(MemberViewModel) saveMemberDetails;
  final Function cancel;

  ProfileEditable({
    @required this.member,
    @required this.firstNameController,
    @required this.lastNameController,
    @required this.emailController,
    @required this.screenSize,
    @required this.saveMemberDetails,
    @required this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: S.of(context).profileFirstNameLabel,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).profileValidateFirstNameMessage;
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: S.of(context).profileLastNameLabel,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).profileValidateLastNameMessage;
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: S.of(context).profileEmailLabel,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).profileValidateEmailMessage;
                } else {
                  if (!EmailValidator.validate(value)) {
                    return S.of(context).profileInvalidEmailMessage;
                  }
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorButton(
                width: 120,
                isUpdating: false,
                label: S.of(context).profileSaveButton,
                onTap: () {
                  saveMemberDetails(member);
                },
              ),
              SizedBox(
                width: 20,
              ),
              ColorButton(
                isUpdating: false,
                label: S.of(context).profileCancelButton,
                onTap: () {
                  cancel();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
