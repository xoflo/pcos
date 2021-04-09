import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_layout.dart';

class Dashboard extends StatelessWidget {
  final bool showYourWhy;

  Dashboard({@required this.showYourWhy});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(showYourWhy: showYourWhy);
  }
}
