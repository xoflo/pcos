import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_generic.dart';

class ProfileDeletePage extends StatefulWidget {
  const ProfileDeletePage({Key? key}) : super(key: key);

  static const String id = "profile_delete_page";

  @override
  State<ProfileDeletePage> createState() => _ProfileDeletePageState();
}

class _ProfileDeletePageState extends State<ProfileDeletePage> {
  bool isDeleting = false;

  void deleteAccount(BuildContext context) async {
    setState(() => isDeleting = true);

    final memberProvider = Provider.of<MemberProvider>(context, listen: false);

    if (memberProvider.isPendingDeletion) {
      try {
        final bool isDeleteSuccessful = await WebServices().deleteMember();
        if (isDeleteSuccessful) {
          Navigator.pushReplacementNamed(context, SignIn.id);
        } else {
          showAlertDialog(
            context,
            "Error",
            "An error has occurred. Please try again later.",
            "",
            "Ok",
            null,
            null,
          );
        }
      } catch (_) {
        showAlertDialog(
          context,
          "Error",
          "An error has occurred. Please try again later.",
          "",
          "Ok",
          null,
          null,
        );
      }
    } else {
      showAlertDialog(
        context,
        "Error",
        "Something went wrong",
        "",
        "Ok",
        null,
        null,
      );
    }

    setState(() => isDeleting = false);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        title: "Delete Account",
                        closeItem: () => Navigator.pop(context),
                        showDivider: true,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        child: Text(
                          """
We're sorry to see you go!

We'll always be here for you when you need us again. 

The Ovie Team
                          """,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: textColor.withOpacity(0.8)),
                        ),
                      ),
                      Spacer(),
                      FilledButton(
                        text: "DELETE ACCOUNT",
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        foregroundColor: Colors.white,
                        backgroundColor: redColor,
                        onPressed: () {
                          showAlertDialog(
                            context,
                            "Warning",
                            """
Upon account deletion, you will be logged out of the app.

Are you sure you want to delete your account? This action cannot be reversed.
                            """,
                            "No",
                            "Yes",
                            deleteAccount,
                            null,
                          );
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      SizedBox(height: 50)
                    ],
                  ),
                ),
                if (isDeleting) GenericLoaderOverlay()
              ],
            ),
          ),
        ),
      );
}
