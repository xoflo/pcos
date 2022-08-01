import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class ProfileDeletePage extends StatefulWidget {
  const ProfileDeletePage({Key? key}) : super(key: key);

  static const String id = "profile_delete_page";

  @override
  State<ProfileDeletePage> createState() => _ProfileDeletePageState();
}

class _ProfileDeletePageState extends State<ProfileDeletePage> {
  bool isUpdating = false;
  @override
  Widget build(BuildContext context) => Scaffold(
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
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: textColor.withOpacity(0.8)),
                  ),
                ),
                Spacer(),
                FilledButton(
                  text: "DELETE ACCOUNT",
                  isUpdating: isUpdating,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  foregroundColor: Colors.white,
                  backgroundColor: redColor,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() => isUpdating = true);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
