import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class MenuLeft extends StatefulWidget {
  final int currentIndex;
  final Function(int selectedIndex) onTapped;

  MenuLeft({@required this.currentIndex, @required this.onTapped});

  @override
  _MenuLeftState createState() => _MenuLeftState();
}

class _MenuLeftState extends State<MenuLeft> {
  String _appVersion = "";
  String _appBuildNumber = "";

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
    final TextStyle footerStyle =
        Theme.of(context).textTheme.headline4.copyWith(fontSize: 12.0);
    final DateTime today = DateTime.now();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.maxFinite,
            height: 100,
            color: primaryColor,
            child: Center(
              child: Text(
                S.of(context).appTitle,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
              ),
            ),
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            color: Colors.white,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(0);
              });
            },
            child: Item(
              0,
              S.of(context).dashboardTitle,
              widget.currentIndex,
              Icons.home,
              true,
            ),
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            color: Colors.white60,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(1);
              });
            },
            child: Item(
              1,
              S.of(context).knowledgeBaseTitle,
              widget.currentIndex,
              Icons.batch_prediction,
              true,
            ),
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            color: Colors.white60,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(2);
              });
            },
            child: Item(
              2,
              S.of(context).recipesTitle,
              widget.currentIndex,
              Icons.local_dining,
              true,
            ),
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            color: Colors.white60,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(3);
              });
            },
            child: Item(
              3,
              S.of(context).favouritesTitle,
              widget.currentIndex,
              Icons.favorite_outline,
              true,
            ),
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            color: Colors.white60,
          ),
          Container(
            height: 1,
            width: double.maxFinite,
            color: primaryColor,
          ),
          Container(
            height: 5,
            width: double.maxFinite,
            color: Colors.white60,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(4);
              });
            },
            child: Item(
              4,
              S.of(context).profileTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            height: 3,
            width: double.maxFinite,
            color: Colors.white60,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(5);
              });
            },
            child: Item(
              5,
              S.of(context).changePasswordTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            height: 3,
            width: double.maxFinite,
            color: Colors.white24,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(6);
              });
            },
            child: Item(
              6,
              S.of(context).requestDataTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            height: 3,
            width: double.maxFinite,
            color: Colors.white24,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(7);
              });
            },
            child: Item(
              7,
              S.of(context).helpTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            height: 3,
            width: double.maxFinite,
            color: Colors.white24,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(8);
              });
            },
            child: Item(
              8,
              S.of(context).supportTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            height: 3,
            width: double.maxFinite,
            color: Colors.white24,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(9);
              });
            },
            child: Item(
              9,
              S.of(context).privacyTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            height: 3,
            width: double.maxFinite,
            color: Colors.white24,
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTapped(10);
              });
            },
            child: Item(
              10,
              S.of(context).termsOfUseTitle,
              widget.currentIndex,
              Icons.arrow_right_outlined,
              false,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 10.0,
            ),
            child: Text(
              "${S.of(context).appTitle} v$_appVersion (build: $_appBuildNumber)",
              style: footerStyle,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 3.0,
            ),
            child: Text(
              "${today.year} \u00a9 ${S.of(context).companyTitle}",
              style: footerStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class Item extends StatefulWidget {
  final int id;
  final String title;
  final int selected;
  final IconData icon;
  final bool isMainMenuItem;

  Item(this.id, this.title, this.selected, this.icon, this.isMainMenuItem);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.selected == widget.id
            ? Border.all(width: 1.0, color: primaryColor)
            : null,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: widget.selected == widget.id ? backgroundColor : Colors.white,
      ),
      child: Padding(
        padding: widget.isMainMenuItem
            ? EdgeInsets.only(left: 16.0, top: 20.0, bottom: 20.0)
            : EdgeInsets.only(left: 3.0, top: 5.0, bottom: 5.0),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: widget.isMainMenuItem ? 24 : 20,
              color: primaryColor,
            ),
            SizedBox(
              width: widget.isMainMenuItem ? 16.0 : 8.0,
            ),
            Text(widget.title, style: TextStyle(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}
