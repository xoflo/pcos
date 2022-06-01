import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';

class ProfileDeletePage extends StatefulWidget {
  const ProfileDeletePage({Key? key}) : super(key: key);

  static const String id = "profile_delete_page";

  @override
  State<ProfileDeletePage> createState() => _ProfileDeletePageState();
}

class _ProfileDeletePageState extends State<ProfileDeletePage> {
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: "Delete Account",
                closeItem: isUpdating ? null : () => Navigator.pop(context),
                showDivider: true,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
              Spacer(),
              FilledButton(
                text: "DELETE ACCOUNT",
                isUpdating: isUpdating,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                foregroundColor: Colors.white,
                backgroundColor: backgroundColor,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() => isUpdating = true);
                },
              ),
              HollowButton(
                onPressed: () => Navigator.pop(context),
                text: "CANCEL",
                isUpdating: isUpdating,
                style: OutlinedButton.styleFrom(
                  primary: backgroundColor,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(
                    color: backgroundColor,
                  ),
                ),
                margin: const EdgeInsets.all(15),
                verticalPadding: 7.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
