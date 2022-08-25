import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/providers/member_provider.dart';

class PreferencesProvider extends ChangeNotifier {
  MemberProvider? memberProvider;

  bool _isShowYourWhy = false;
  bool get isShowYourWhy => _isShowYourWhy;

  bool _isShowLessonRecipes = false;
  bool get isShowLessonRecipes => _isShowLessonRecipes;

  bool _isUsernameUsed = false;
  bool get isUsernameUsed => _isUsernameUsed;

  PreferencesProvider({required MemberProvider? memberProvider}) {
    this.memberProvider = memberProvider;
    if (memberProvider != null) getIsShowYourWhy();
  }

  void getIsShowYourWhy() async {
    _isShowYourWhy = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    notifyListeners();
  }

  Future<void> saveDisplayWhy(final bool isOn) async {
    await PreferencesController()
        .saveBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED, isOn);
    getIsShowYourWhy();
  }

  // ///////

  void getIsShowLessonRecipes() async {
    _isShowLessonRecipes = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    notifyListeners();
  }

  Future<void> saveIsShowLessonRecipes(final bool isOn) async {
    PreferencesController().saveBool(
        SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD, isOn);
    getIsShowLessonRecipes();
  }

  // ///////

  void getIsUsernameUsed() async {
    _isUsernameUsed = await PreferencesController()
        .getBool(SharedPreferencesKeys.USERNAME_USED);

    _preferredDisplayName = _getPreferredDisplayNameValue();
    notifyListeners();
  }

  Future<void> saveIsUsernameUsed(final bool isOn) async {
    PreferencesController().saveBool(SharedPreferencesKeys.USERNAME_USED, isOn);
    getIsUsernameUsed();
  }

  // ////////

  String _preferredDisplayName = "";
  String get preferredDisplayName {
    return _getPreferredDisplayNameValue();
  }

  String _getPreferredDisplayNameValue() {
    _preferredDisplayName =
        (isUsernameUsed ? memberProvider?.alias : memberProvider?.firstName) ??
            "";
    return _preferredDisplayName;
  }
}
