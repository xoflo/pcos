import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:package_info/package_info.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';

class DrawerMenu extends StatefulWidget {
  final Function(AppState) updateAppState;

  DrawerMenu({this.updateAppState});

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
        Theme.of(context).textTheme.headline4.copyWith(
              fontSize: 20.0,
              color: primaryColorDark,
            );
    final TextStyle footerStyle =
        Theme.of(context).textTheme.headline4.copyWith(
              fontSize: 14.0,
              color: primaryColorDark,
            );
    final DateTime today = DateTime.now();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: Platform.isIOS ? 120.0 : 115.0,
            child: DrawerHeader(
              child: Column(
                children: [
                  Text(
                    S.of(context).appTitle,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: primaryColorDark,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        widget.updateAppState(AppState.LOCKED);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Lock App",
                              style: TextStyle(
                                color: primaryColorDark,
                              )),
                          Icon(
                            Icons.lock_outline,
                            size: 24.0,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).profileTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).changePasswordTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).requestDataTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).helpTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).supportTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).privacyTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).termsOfUseTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context);
            },
          ),
          SizedBox(height: 30.0),
          ListTile(
            title: Text(
              "${S.of(context).appTitle} v$_appVersion (build: $_appBuildNumber)",
              style: footerStyle,
            ),
          ),
          ListTile(
            title: Text(
              "${today.year} \u00a9 ${S.of(context).companyTitle}",
              style: footerStyle,
            ),
          ),
        ],
      ),
    );
  }
}
