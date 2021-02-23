import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class PreferencesController {
  Future<bool> saveViewedTutorial() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedPreferencesKeys.VIEWED_TUTORIAL, true);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> getViewedTutorial() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isViewed =
          prefs.getBool(SharedPreferencesKeys.VIEWED_TUTORIAL);
      return isViewed != null ? isViewed : false;
    } catch (ex) {
      return true;
    }
  }
}
