import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_unlock.dart';
import 'package:thepcosprotocol_app/screens/notifications/notifications.dart';
import 'package:thepcosprotocol_app/screens/tabs/more/app_help.dart';
import 'package:thepcosprotocol_app/screens/tabs/more/privacy.dart';
import 'package:thepcosprotocol_app/screens/tabs/more/terms_and_conditions.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/app_tutorial/app_tutorial_page.dart';
import '/widgets/shared/filled_button.dart' as Ovie;

class MorePage extends StatelessWidget {
  const MorePage({Key? key, required this.onLockApp}) : super(key: key);

  final Function(bool) onLockApp;

  Widget _renderItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
          title: Text("Tutorial"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(
            context,
            AppTutorialPage.id,
            arguments: AppTutorialArguments(
              showBackButton: true,
            ),
          ),
        );
      case 1:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
          title: Text("App help"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, AppHelp.id),
        );
      case 2:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
          title: Text("Privacy policy"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, Privacy.id),
        );
      case 3:
        return ListTile(
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
          title: Text("Terms of use"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushNamed(context, TermsAndConditions.id),
        );
      default:
        break;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final width = ((MediaQuery.of(context).size.width) / 2) - 30;
    return SafeArea(
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Ovie.FilledButton(
                    text: "Lock app",
                    icon: Icon(Icons.lock_outline, size: 18),
                    margin: EdgeInsets.zero,
                    width: width,
                    foregroundColor: Colors.white,
                    backgroundColor: backgroundColor,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PinUnlock.id,
                        arguments: PinUnlockArguments(true, onLockApp),
                      );
                      onLockApp(true);
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Ovie.FilledButton(
                    text: "Notifications",
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: 18,
                    ),
                    margin: EdgeInsets.zero,
                    width: width,
                    foregroundColor: Colors.white,
                    backgroundColor: backgroundColor,
                    onPressed: () =>
                        Navigator.pushNamed(context, Notifications.id),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      if (index == 0)
                        Divider(thickness: 1, height: 1, color: dividerColor),
                      _renderItem(context, index),
                      Divider(thickness: 1, height: 1, color: dividerColor),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
