import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/authentication.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _refreshToken = "";
  String _backgroundTimestamp = "";

  @override
  void initState() {
    super.initState();
    getRefreshToken();
  }

  void getRefreshToken() async {
    final String token = await Authentication().getRefreshToken();
    final int timeStamp = await Authentication().getBackgroundedTimestamp();

    setState(() {
      _refreshToken = token;
      _backgroundTimestamp = timeStamp.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("RefreshToken=$_refreshToken"),
        Text("BackgroundTimestamp=$_backgroundTimestamp")
      ],
    );
  }
}
