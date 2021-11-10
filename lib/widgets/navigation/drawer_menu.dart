import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/constants/drawer_menu_item.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class DrawerMenu extends StatefulWidget {
  final Function(DrawerMenuItem) openDrawerMenuItem;

  DrawerMenu({@required this.openDrawerMenuItem});

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String _appVersion = "";
  String _appBuildNumber = "";

  void _drawerNavigation(BuildContext context, DrawerMenuItem drawerMenuItem) {
    widget.openDrawerMenuItem(drawerMenuItem);
  }

  void _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _appBuildNumber = packageInfo.buildNumber;
    });
  }

  //TODO: check what needs updating here
  void _resetDataCache() {
    saveTimestamp("KnowledgeBase");
    saveTimestamp("AppHelp");
    saveTimestamp("CourseQuestion");
    saveTimestamp("Recipe");
    saveTimestamp("Message");
    saveTimestamp("CMSText");
    saveTimestamp("Module");
    saveTimestamp("Lesson");
    saveTimestamp("LessonContent");
    saveTimestamp("LessonTask");
  }

  Future<bool> saveTimestamp(final String tableName) async {
    try {
      final String key =
          "${tableName}_${SharedPreferencesKeys.DB_SAVED_TIMESTAMP}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(
          key, DateTime.now().add(Duration(days: -1)).millisecondsSinceEpoch);
      return true;
    } catch (ex) {
      return false;
    }
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
              color: primaryColor,
            );
    final TextStyle footerStyle =
        Theme.of(context).textTheme.headline4.copyWith(
              fontSize: 14.0,
              color: primaryColor,
            );
    final DateTime today = DateTime.now();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: Platform.isIOS ? 132.0 : 115.0,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    S.of(context).appTitle,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: primaryColor,
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _drawerNavigation(context, DrawerMenuItem.SETTINGS);
                        },
                        child: Icon(
                          Icons.settings,
                          size: 24.0,
                          color: primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _drawerNavigation(context, DrawerMenuItem.LOCK);
                        },
                        child: Row(
                          children: [
                            Text("Lock App",
                                style: TextStyle(
                                  color: primaryColor,
                                )),
                            Icon(
                              Icons.lock_outline,
                              size: 24.0,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
              _drawerNavigation(context, DrawerMenuItem.PROFILE);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).changePasswordTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context, DrawerMenuItem.CHANGE_PASSWORD);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).appHelpTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context, DrawerMenuItem.APP_HELP);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).privacyTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context, DrawerMenuItem.PRIVACY);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).termsOfUseTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context, DrawerMenuItem.TERMS_OF_USE);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).tutorialTitle,
              style: drawerItemStyle,
            ),
            onTap: () {
              _drawerNavigation(context, DrawerMenuItem.TUTORIAL);
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
          FlavorConfig.isDev() || !Foundation.kReleaseMode
              ? ListTile(
                  title: Text(
                    "Reset Data Cache",
                    style: drawerItemStyle,
                  ),
                  onTap: () {
                    _resetDataCache();
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
