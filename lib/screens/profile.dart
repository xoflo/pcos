import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_layout.dart';

class Profile extends StatelessWidget {
  final Function closeMenuItem;

  Profile({this.closeMenuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: ChangeNotifierProvider(
            create: (context) => MemberViewModel(),
            child: ProfileLayout(
              closeMenuItem: closeMenuItem,
            ),
          ),
        ),
      ),
    );
  }
}
