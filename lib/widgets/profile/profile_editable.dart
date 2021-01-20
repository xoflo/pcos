import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class ProfileEditable extends StatelessWidget {
  final MemberViewModel member;
  final Size screenSize;
  final formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final Function saveMemberDetails;
  final Function cancel;

  ProfileEditable(
      {@required this.member,
      @required this.formKey,
      @required this.firstNameController,
      @required this.lastNameController,
      @required this.emailController,
      @required this.screenSize,
      @required this.saveMemberDetails,
      @required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
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
                  }
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorButton(
                  label: S.of(context).profileSaveButton,
                  onTap: saveMemberDetails,
                ),
                SizedBox(
                  width: 20,
                ),
                ColorButton(
                  label: S.of(context).profileCancelButton,
                  onTap: cancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
