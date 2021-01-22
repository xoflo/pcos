import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/utils/error_utils.dart';

class ChangePasswordLayout extends StatefulWidget {
  final Function closeMenuItem;

  ChangePasswordLayout({
    @required this.closeMenuItem,
  });

  @override
  _ChangePasswordLayoutState createState() => _ChangePasswordLayoutState();
}

class _ChangePasswordLayoutState extends State<ChangePasswordLayout> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  void _savePassword() async {
    if (_formKey.currentState.validate()) {
      String oldPassword = oldPasswordController.text.trim();
      String newPassword = newPasswordController.text.trim();
      String usernameOrEmail = "";

      //check old password is correct, this is like logging in, so will return a new token that replaces the old one
      try {
        usernameOrEmail = await AuthenticationController().getUsernameOrEmail();
        final bool checkPassword = await AuthenticationController()
            .signIn(usernameOrEmail, oldPassword);
        debugPrint("email=$usernameOrEmail checkPwd=$checkPassword");
      } catch (ex) {
        if (ex == SIGN_IN_CREDENTIALS) {
          //password must have been wrong
          _displayMessage(
            false,
            S.of(context).changePasswordOldPasswordWrongTitle,
            S.of(context).changePasswordOldPasswordWrongMessage,
          );
        } else {
          //something else went wrong checking password
          _displayMessage(false, S.of(context).changePasswordFailedTitle,
              S.of(context).changePasswordFailedMessage);
        }
        setState(() {
          isLoading = false;
        });
        return;
      }

      //current password was correct so continue to update the new password
      try {
        final bool resetPassword =
            await WebServices().resetPassword(usernameOrEmail, newPassword);
        debugPrint("resetPwd=$resetPassword");
        if (resetPassword) {
          _displayMessage(true, S.of(context).changePasswordSuccessTitle,
              S.of(context).changePasswordSuccessMessage);
          widget.closeMenuItem();
        }
      } catch (ex) {
        //something unexpected went wrong
        _displayMessage(false, S.of(context).changePasswordFailedTitle,
            S.of(context).changePasswordFailedMessage);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void _cancel() {
    widget.closeMenuItem();
  }

  void _displayMessage(
      final bool isSuccess, final String title, final String message) {
    final Color borderColor = isSuccess ? Colors.green : primaryColorLight;
    final Color primaryColor = isSuccess ? Colors.green : primaryColorDark;

    showFlushBar(context, title, message,
        backgroundColor: Colors.white,
        borderColor: borderColor,
        primaryColor: primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(
                itemId: 0,
                favouriteType: FavouriteType.None,
                title: S.of(context).changePasswordTitle,
                isFavourite: false,
                closeItem: widget.closeMenuItem,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).changePasswordOldLabel,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).changePasswordOldMessage;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).changePasswordNewLabel,
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return S.of(context).changePasswordNewMessage;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).changePasswordConfirmLabel,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).changePasswordConfirmMessage;
                    } else {
                      if (value != newPasswordController.text) {
                        return S.of(context).changePasswordDifferentMessage;
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
                    label: S.of(context).changePasswordSaveButton,
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      _savePassword();
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ColorButton(
                    label: S.of(context).profileCancelButton,
                    onTap: () {
                      _cancel();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
