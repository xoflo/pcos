import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/settings/toggle_switch.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/preferences_provider.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class SettingsLayout extends StatefulWidget {
  final Function(bool) updateYourWhy;
  final Function(bool) updateLessonRecipes;
  final Function(bool) updateUseUsername;

  SettingsLayout({
    required this.updateYourWhy,
    required this.updateLessonRecipes,
    required this.updateUseUsername,
  });

  @override
  _SettingsLayoutState createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  @override
  void initState() {
    super.initState();
    _initialiseSettings();
  }

  Future<void> _initialiseSettings() async {
    final bool isYourWhyOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    final bool isLessonRecipesOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    final bool isUseUsernameOn = await PreferencesController()
        .getBool(SharedPreferencesKeys.USERNAME_USED);

    setState(() {
      _preferenceOptions.addAll({
        "Display “Your Why”": isYourWhyOn,
        "Display lesson recipes": isLessonRecipesOn,
        "Use username": isUseUsernameOn,
      });
    });
  }

  Map<String, bool> _preferenceOptions = {};

  @override
  Widget build(BuildContext context) {
    PreferencesProvider prefsProvider =
        Provider.of<PreferencesProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: "Account Preferences",
            closeItem: () => Navigator.pop(context),
            showDivider: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _preferenceOptions.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: ToggleSwitch(
                        title: _preferenceOptions.keys.elementAt(index),
                        value: _preferenceOptions.values.elementAt(index),
                        onToggle: (isOn) {
                          final key = _preferenceOptions.keys.elementAt(index);

                          setState(() {
                            _preferenceOptions.addAll({key: isOn});
                          });

                          switch (index) {
                            case 0:
                              prefsProvider.saveDisplayWhy(isOn);
                              break;
                            case 1:
                              prefsProvider.saveIsShowLessonRecipes(isOn);
                              break;
                            case 2:
                              prefsProvider.saveIsUsernameUsed(isOn);
                              break;
                            default:
                              break;
                          }
                        }),
                  ),
                  Divider(thickness: 1, height: 1, color: dividerColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
