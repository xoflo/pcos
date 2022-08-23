import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_personal_details_layout.dart';

class ProfilePersonalDetails extends StatelessWidget {
  const ProfilePersonalDetails({Key? key}) : super(key: key);

  static const String id = "profile_personal_details";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: ProfilePersonalDetailsLayout(),
      );
}
