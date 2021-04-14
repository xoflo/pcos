import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_layout.dart';

class Dashboard extends StatelessWidget {
  final bool showYourWhy;
  final Function(bool) updateYourWhy;

  Dashboard({@required this.showYourWhy, @required this.updateYourWhy});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        showYourWhy: showYourWhy, updateYourWhy: updateYourWhy);
  }
}
