import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController {
  Future<bool> saveBool(final String sharedPreferencesKey) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(sharedPreferencesKey, true);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> getBool(final String sharedPreferencesKey) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool prefValue = prefs.getBool(sharedPreferencesKey);
      return prefValue != null ? prefValue : false;
    } catch (ex) {
      return true;
    }
  }

  Future<bool> saveString(
      final String sharedPreferencesKey, final String newValue) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(sharedPreferencesKey, newValue);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<String> getString(final String sharedPreferencesKey) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String prefValue = prefs.getString(sharedPreferencesKey);
      return prefValue != null ? prefValue : "";
    } catch (ex) {
      return "";
    }
  }
}
