import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_personal_details_layout.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ProfilePersonalDetails extends StatelessWidget {
  const ProfilePersonalDetails({Key? key}) : super(key: key);

  static const String id = "profile_personal_details";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: ChangeNotifierProvider(
          create: (context) => MemberProvider(),
          builder: (context, _) => Consumer<MemberProvider>(
            builder: (context, memberProvider, child) =>
                ProfilePersonalDetailsLayout(memberProvider: memberProvider),
          ),
        ),
      );
}
