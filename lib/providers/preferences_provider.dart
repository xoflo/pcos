import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/providers/member_provider.dart';

class PreferencesProvider extends PropertyChangeNotifier<String> {
  late MemberProvider _memberProvider;
  MemberProvider get memberProvider => _memberProvider;

  bool _isShowYourWhy = false;
  bool get isShowYourWhy => _isShowYourWhy;

  bool _isShowLessonRecipes = false;
  bool get isShowLessonRecipes => _isShowLessonRecipes;

  bool _isUsernameUsed = false;
  bool get isUsernameUsed => _isUsernameUsed;

  set memberProvider(MemberProvider memberProvider) {
    _memberProvider = memberProvider;
    notifyListeners();
  }

  void getIsShowYourWhy() async {
    _isShowYourWhy = await PreferencesController()
        .getBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
    notifyListeners('isShowYourWhy');
  }

  Future<void> saveDisplayWhy(final bool isOn) async {
    await PreferencesController()
        .saveBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED, isOn);
    getIsShowYourWhy();
  }

  // ///////

  void _getIsShowLessonRecipes() async {
    _isShowLessonRecipes = await PreferencesController()
        .getBool(SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD);
    notifyListeners('isShowLessonRecipes');
  }

  Future<void> saveIsShowLessonRecipes(final bool isOn) async {
    PreferencesController().saveBool(
        SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD, isOn);
    _getIsShowLessonRecipes();
  }

  // ///////

  void _getIsUsernameUsed() async {
    _isUsernameUsed = await PreferencesController()
        .getBool(SharedPreferencesKeys.USERNAME_USED);
    notifyListeners('isUsernameUsed');
  }

  Future<void> saveIsUsernameUsed(final bool isOn) async {
    PreferencesController().saveBool(SharedPreferencesKeys.USERNAME_USED, isOn);
    _getIsUsernameUsed();
  }

  // ////////

  String getPreferredDisplayName() {
    String displayedName =
        isUsernameUsed ? memberProvider.alias : memberProvider.firstName;

    return displayedName;
  }
}
