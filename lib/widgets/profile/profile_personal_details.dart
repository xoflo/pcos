import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_personal_details_layout.dart';

class ProfilePersonalDetails extends StatelessWidget {
  const ProfilePersonalDetails({Key? key}) : super(key: key);

  static const String id = "profile_personal_details";

  @override
  Widget build(BuildContext context) => WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: Scaffold(
                backgroundColor: primaryColor,
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: ChangeNotifierProvider(
                      create: (context) => MemberViewModel(),
                      child: ProfilePersonalDetailsLayout(),
                    ),
                  ),
                ),
              ),
          );
}
