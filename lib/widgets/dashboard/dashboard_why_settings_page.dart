import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_why_settings_layout.dart';

class DashboardWhySettingsPage extends StatelessWidget {
  const DashboardWhySettingsPage({Key? key}) : super(key: key);

  static const id = "dashboard_why_settings_page";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 12.0,
            ),
            child: ChangeNotifierProvider(
              create: (context) => MemberViewModel(),
              child: DashboardWhySettingsLayout(),
            ),
          ),
        ),
      );
}
