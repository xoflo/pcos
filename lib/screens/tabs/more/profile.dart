import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_layout.dart';

class Profile extends StatelessWidget {
  static const String id = "profile_screen";

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: 12.0,
              ),
              child: ChangeNotifierProvider(
                create: (context) => MemberProvider(),
                child: ProfileLayout(),
              ),
            ),
          ),
        ),
      );
}
