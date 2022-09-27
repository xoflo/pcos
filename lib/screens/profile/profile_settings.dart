import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/navigation/settings_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_set.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/screens/tabs/more/change_password.dart';
import 'package:thepcosprotocol_app/screens/tabs/more/settings.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_delete_page.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_personal_details.dart';
import 'package:thepcosprotocol_app/screens/profile/profile_settings_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class ProfileSettings extends StatefulWidget {
  const ProfileSettings(
      {Key? key, required this.email, this.onRefreshUserDetails})
      : super(key: key);

  final String email;
  final Function()? onRefreshUserDetails;

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String _appVersion = "";
  // ignore: unused_field
  bool _showYourWhy = false;
  // ignore: unused_field
  bool _showLessonRecipes = false;
  // ignore: unused_field
  bool _showUseUsername = false;

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
    _initializeAccountPreferences();
  }

  void _initializeAccountPreferences() async {
    //get the value for showYourWhy, and then pass down to the course screen
    final bool isYourWhyOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    final bool isLessonRecipesOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    final bool isUsernameUsed = await PreferencesController()
        .getBool(SharedPreferencesKeys.USERNAME_USED);

    _showYourWhy = isYourWhyOn;
    _showLessonRecipes = isLessonRecipesOn;
    _showUseUsername = isUsernameUsed;
  }

  void _updateYourWhy(bool isOn) => setState(() => _showYourWhy = isOn);

  void _updateUsernameUsed(bool isOn) =>
      setState(() => _showUseUsername = isOn);

  void _updateLessonRecipes(bool isOn) =>
      setState(() => _showLessonRecipes = isOn);

  Widget _renderItems(int index) {
    switch (index) {
      case 0:
        return ProfileSettingsItem(
          title: "Personal details",
          onTap: () =>
              Navigator.pushNamed(context, ProfilePersonalDetails.id).then(
            (value) {
              if (value is bool && value == true) {
                widget.onRefreshUserDetails?.call();
              }
            },
          ),
        );

      case 1:
        return ProfileSettingsItem(
          title: "Account preferences",
          onTap: () => Navigator.pushNamed(
            context,
            Settings.id,
            arguments: SettingsArguments(
              _updateYourWhy,
              _updateLessonRecipes,
              _updateUsernameUsed,
            ),
          ),
        );

      case 2:
        return ProfileSettingsItem(
          title: "Change PIN number",
          onTap: () => Navigator.pushNamed(context, PinSet.id, arguments: true),
        );
      case 3:
        return ProfileSettingsItem(
          title: "Change password",
          onTap: () => Navigator.pushNamed(context, ChangePassword.id),
        );

      case 4:
        return ProfileSettingsItem(
          title: "Delete account",
          onTap: () => Navigator.pushNamed(context, ProfileDeletePage.id),
        );
      default:
        break;
    }
    return Container();
  }

  void _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() =>
        _appVersion = "${packageInfo.version} (${packageInfo.buildNumber})");
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView.builder(
              itemCount: 5,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Column(
                children: <Widget>[
                  _renderItems(index),
                  Divider(thickness: 1, height: 1, color: dividerColor),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "Signed in as ${widget.email}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: textColor.withOpacity(0.8)),
                ),
                SizedBox(height: 10),
                Text(
                  "Version $_appVersion",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(color: textColor.withOpacity(0.8)),
                ),
                HollowButton(
                  onPressed: () {
                    AuthenticationController().clearData(context);

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SignIn.id, (Route<dynamic> route) => false);
                  },
                  text: "LOG OUT",
                  style: OutlinedButton.styleFrom(
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
                  verticalPadding: 5,
                  textColor: backgroundColor,
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      );
}
