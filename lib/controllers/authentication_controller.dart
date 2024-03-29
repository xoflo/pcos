import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/secure_storage_keys.dart'
    as SecureStorageKeys;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/one_signal_controller.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/global_vars.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/utils/local_notifications_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class AuthenticationController {
  Future<bool> signIn(String emailOrUsername, String password) async {
    final token = await WebServices().signIn(emailOrUsername, password);
    if ((token?.accessToken ?? "").length > 0) {
      //save the username or email in secure storage so it can be used during change password process
      await secureStorage.write(
          key: SecureStorageKeys.EMAIL, value: token?.profile?.email);
      await secureStorage.write(
          key: SecureStorageKeys.USERNAME, value: token?.profile?.alias);
      await secureStorage.write(
          key: SecureStorageKeys.ACCESS_TOKEN, value: token?.accessToken);
      await secureStorage.write(
          key: SecureStorageKeys.REFRESH_TOKEN, value: token?.refreshToken);
      await secureStorage.write(
          key: SecureStorageKeys.USER_ID, value: token?.profile?.id.toString());
      //use the SharedPreferences not controller for this as want to check for null
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? isUserSignedIn =
          prefs.getBool(SharedPreferencesKeys.IS_USER_SIGNED_IN);
      PreferencesController()
          .saveBool(SharedPreferencesKeys.IS_USER_SIGNED_IN, true);
      PreferencesController().saveString(
          SharedPreferencesKeys.PCOS_TYPE, token?.profile?.pcosType);
      if ((token?.profile?.whatsMyWhy ?? "").length > 0) {
        await PreferencesController().saveString(
            SharedPreferencesKeys.WHATS_YOUR_WHY, token?.profile?.whatsMyWhy);
      }
      // Automatically show the what's your why, regardless if they are
      // available or not, so that they can edit it later on
      if (isUserSignedIn == null) {
        await PreferencesController()
            .saveBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED, true);
      }
      //set the dashboard to NOT show lesson recipes by default
      if (prefs.getBool(
              SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD) ==
          null) {
        await PreferencesController().saveBool(
            SharedPreferencesKeys.LESSON_RECIPES_DISPLAYED_DASHBOARD, false);
      }

      return true;
    }

    return false;
  }

  Future<bool> refreshToken() async {
    try {
      final token = await WebServices().refreshToken();

      if ((token?.accessToken ?? "").length > 0) {
        //save the tokens to secure storage
        await secureStorage.write(
            key: SecureStorageKeys.ACCESS_TOKEN, value: token?.accessToken);
        await secureStorage.write(
            key: SecureStorageKeys.REFRESH_TOKEN, value: token?.refreshToken);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if ((token?.profile?.whatsMyWhy ?? "").length > 0) {
          await prefs.setString(SharedPreferencesKeys.WHATS_YOUR_WHY,
              token?.profile?.whatsMyWhy ?? "");
        }
        await prefs.setString(
            SharedPreferencesKeys.PCOS_TYPE, token?.profile?.pcosType ?? "");
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      final forgotPasswordSuccessful =
          await WebServices().forgotPassword(email);
      return forgotPasswordSuccessful;
    } catch (ex) {
      throw ex;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final String? token =
          await secureStorage.read(key: SecureStorageKeys.ACCESS_TOKEN);
      return token;
    } catch (ex) {
      return "";
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final String? refreshToken =
          await secureStorage.read(key: SecureStorageKeys.REFRESH_TOKEN);
      return refreshToken;
    } catch (ex) {
      return "";
    }
  }

  Future<String> getStreamIOToken() async {
    try {
      return await WebServices().getStreamIOToken();
    } catch (ex) {
      return '';
    }
  }

  Future<String?> getUsername() async {
    try {
      final String? username =
          await secureStorage.read(key: SecureStorageKeys.USERNAME);
      return username;
    } catch (ex) {
      return "";
    }
  }

  Future<String?> getEmail() async {
    try {
      final String? email =
          await secureStorage.read(key: SecureStorageKeys.EMAIL);
      return email;
    } catch (ex) {
      return "";
    }
  }

  Future<String?> getUserId() async {
    try {
      final String? email =
          await secureStorage.read(key: SecureStorageKeys.USER_ID);
      return email;
    } catch (ex) {
      return "";
    }
  }

  Future<String?> getLastLoggedInUserId() async {
    try {
      final String? email = await secureStorage.read(
          key: SecureStorageKeys.LAST_LOGGED_IN_USER_ID);
      return email;
    } catch (ex) {
      return "";
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final String? refreshToken =
          await secureStorage.read(key: SecureStorageKeys.REFRESH_TOKEN);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return refreshToken != null &&
          refreshToken.length > 0 &&
          prefs.getBool(SharedPreferencesKeys.IS_USER_SIGNED_IN) == true;
    } catch (ex) {
      return false;
    }
  }

  Future<void> saveLastLoggedInUserId() async {
    await secureStorage.write(
          key: SecureStorageKeys.LAST_LOGGED_IN_USER_ID, value: await getUserId());
  }

  Future<bool> _deleteCredentials() async {
    try {
      await secureStorage.delete(key: SecureStorageKeys.ACCESS_TOKEN);
      await secureStorage.delete(key: SecureStorageKeys.REFRESH_TOKEN);
      await secureStorage.delete(key: SecureStorageKeys.USER_ID);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(SharedPreferencesKeys.IS_USER_SIGNED_IN);
      return true;
    } catch (ex) {
      return false;
    }
  }

  void _deleteCookies() {
    final cookieManager = CookieManager();
    cookieManager.clearCookies();
  }

  Future<bool> savePin(String pin) async {
    try {
      await secureStorage.write(key: SecureStorageKeys.PIN, value: pin);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedPreferencesKeys.IS_USER_PIN_SET, true);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> checkPin(final String pinEntered) async {
    try {
      final String? pinFromSecureStorage =
          await secureStorage.read(key: SecureStorageKeys.PIN);

      return pinFromSecureStorage == pinEntered;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> _deletePin() async {
    try {
      await secureStorage.delete(key: SecureStorageKeys.PIN);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(SharedPreferencesKeys.IS_USER_PIN_SET);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> _deleteOtherPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(SharedPreferencesKeys.BACKGROUNDED_TIMESTAMP);
      prefs.remove(SharedPreferencesKeys.DB_SAVED_TIMESTAMP);
      prefs.remove(SharedPreferencesKeys.INTERCOM_REGISTERED);
      prefs.remove(SharedPreferencesKeys.VIEWED_TUTORIAL);
      prefs.remove(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);
      prefs.remove(SharedPreferencesKeys.DAILY_REMINDER_TIME);
      prefs.remove(SharedPreferencesKeys.APP_FIRST_USE_TIMESTAMP);
      prefs.remove(SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION);
      prefs.remove(SharedPreferencesKeys.ONE_SIGNAL_DATA_SENT);
      prefs.remove(SharedPreferencesKeys.NEXT_LESSON_AVAILABLE_DATE);
      prefs.remove(SharedPreferencesKeys.YOUR_WHY_DISPLAYED);
      prefs.remove(SharedPreferencesKeys.WHATS_YOUR_WHY);
      prefs.remove(SharedPreferencesKeys.PCOS_TYPE);
      prefs.remove(SharedPreferencesKeys.SEARCH_ITEMS);
      prefs.remove(SharedPreferencesKeys.RECIPE_SEARCH_DEFAULT);
      prefs.remove(SharedPreferencesKeys.RECIPE_SEARCH_DIETS);
      prefs.remove(SharedPreferencesKeys.RECIPE_SEARCH_MEALS);
      prefs.remove(SharedPreferencesKeys.USERNAME_USED);
      prefs.remove(SharedPreferencesKeys.TURN_NOTIFICATION_ON_REMIND_TIMES);
      prefs.remove(SharedPreferencesKeys.NOTIFICATION_PROMPT_CHECK_TIMESTAMP);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> isUserPinSet() async {
    try {
      final String? userPin =
          await secureStorage.read(key: SecureStorageKeys.PIN);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return userPin != null &&
          userPin.length > 0 &&
          prefs.getBool(SharedPreferencesKeys.IS_USER_PIN_SET) == true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> saveBackgroundedTimestamp(
      final int backgroundedTimestamp) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(
          SharedPreferencesKeys.BACKGROUNDED_TIMESTAMP, backgroundedTimestamp);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<int?> getBackgroundedTimestamp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(SharedPreferencesKeys.BACKGROUNDED_TIMESTAMP);
    } catch (ex) {
      return 0;
    }
  }

  Future<bool> saveIntercomRegistered() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedPreferencesKeys.INTERCOM_REGISTERED, true);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> getIntercomRegistered() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? isRegistered =
          prefs.getBool(SharedPreferencesKeys.INTERCOM_REGISTERED);

      return isRegistered == true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> getOneSignalSent() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? oneSignalSent =
          prefs.getBool(SharedPreferencesKeys.ONE_SIGNAL_DATA_SENT);

      return oneSignalSent == true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> saveOneSignalSent() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SharedPreferencesKeys.ONE_SIGNAL_DATA_SENT, true);
      return true;
    } catch (ex) {
      return false;
    }
  }

  void clearData(BuildContext context) {
    // Clear database
    Provider.of<DatabaseProvider>(context, listen: false).deleteAllData();

    _deleteCredentials();
    _deletePin();
    _deleteOtherPrefs();

    // Clear all cookies, likely in response to a logout event
    _deleteCookies();

    turnOffDailyReminderNotification(localNotificationsPlugin);

    OneSignalController().deleteOneSignal();
  }
}
