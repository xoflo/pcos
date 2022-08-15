import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_why_settings_layout.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';

class DashboardWhySettingsPage extends StatelessWidget {
  const DashboardWhySettingsPage({Key? key}) : super(key: key);

  static const id = "dashboard_why_settings_page";

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        body: Consumer<MemberProvider>(
          builder: (context, memberProvider, child) =>
                DashboardWhySettingsLayout(memberProvider: memberProvider),
        ),
      );
}
