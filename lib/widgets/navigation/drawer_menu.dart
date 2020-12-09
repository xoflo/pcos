import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:package_info/package_info.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String _appVersion = "";
  String _appBuildNumber = "";

  void _drawerNavigation(BuildContext context) {
    debugPrint("Open drawer item");
    Navigator.pop(context);
  }

  void _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _appBuildNumber = packageInfo.buildNumber;
    });
  }

  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle drawerItemStyle =
        Theme.of(context).textTheme.headline4.copyWith(fontSize: 20.0);
    final TextStyle footerStyle =
        Theme.of(context).textTheme.headline4.copyWith(fontSize: 14.0);
    final DateTime today = DateTime.now();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: Platform.isIOS ? 150.0 : 100.0,
            child: DrawerHeader(
              child: Text(
                "The PCOS Protocol",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Profile",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              "Change Password",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              "Request Data",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              "Help",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              "Support",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              "Privacy",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              "Terms of use",
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          SizedBox(height: 30.0),
          ListTile(
            title: Text(
              "The PCOS Protocol v$_appVersion (build: $_appBuildNumber)",
              style: footerStyle,
            ),
          ),
          ListTile(
            title: Text(
              "${today.year} \u00a9 The PCOS Nutritionist",
              style: footerStyle,
            ),
          ),
        ],
      ),
    );
  }
}
