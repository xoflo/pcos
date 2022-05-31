import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_set.dart';
import 'package:thepcosprotocol_app/screens/menu/app_help.dart';
import 'package:thepcosprotocol_app/screens/menu/change_password.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String _appVersion = "";

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  Widget _renderItems(int index) {
    switch (index) {
      case 0:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 35),
          title: Text("Personal details"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, AppHelp.id),
        );
      case 1:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 35),
          title: Text("Account preferences"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, AppHelp.id),
        );
      case 2:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 35),
          title: Text("Change pin number"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, PinSet.id),
        );
      case 3:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 35),
          title: Text("Change password"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, ChangePassword.id),
        );
      case 4:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 35),
          title: Text("Delete account"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, AppHelp.id),
        );
      default:
        break;
    }
    return Container();
  }

  void _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() => _appVersion = packageInfo.version);
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Column(
                children: <Widget>[
                  _renderItems(index),
                  Divider(thickness: 1, height: 1, color: dividerColor),
                ],
              ),
            ),
            Spacer(),
            Text(
              "Signed in as ${widget.email}",
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 10),
            Text(
              "Version $_appVersion",
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            HollowButton(
              onPressed: () {},
              text: "LOG OUT",
              style: OutlinedButton.styleFrom(
                primary: backgroundColor,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  width: 1,
                  color: backgroundColor,
                ),
              ),
              margin: const EdgeInsets.all(15),
              verticalPadding: 10,
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      );
}
