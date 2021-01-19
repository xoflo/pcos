import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/secure_storage_keys.dart'
    as SecureStorageKeys;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class AuthenticationController {
  Future<bool> signIn(String emailAddress, String password) async {
    try {
      final token = await WebServices().signIn(emailAddress, password);

      if (token.accessToken.length > 0) {
        await secureStorage.write(
            key: SecureStorageKeys.ACCESS_TOKEN, value: token.accessToken);
        await secureStorage.write(
            key: SecureStorageKeys.REFRESH_TOKEN, value: token.refreshToken);
        await secureStorage.write(
            key: SecureStorageKeys.USER_ID, value: token.profile.id.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(SharedPreferencesKeys.IS_USER_SIGNED_IN, true);
        return true;
      }
    } catch (ex) {
      return false;
    }
    return false;
  }

  Future<String> getAccessToken() async {
    try {
      final String token =
          await secureStorage.read(key: SecureStorageKeys.ACCESS_TOKEN);
      return token;
    } catch (ex) {
      return "";
    }
  }

  Future<String> getRefreshToken() async {
    try {
      final String refreshToken =
          await secureStorage.read(key: SecureStorageKeys.REFRESH_TOKEN);
      return refreshToken;
    } catch (ex) {
      return "";
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final String refreshToken =
          await secureStorage.read(key: SecureStorageKeys.REFRESH_TOKEN);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (refreshToken.length > 0 &&
          prefs.getBool(SharedPreferencesKeys.IS_USER_SIGNED_IN)) {
        return true;
      }

      return false;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> deleteCredentials() async {
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
      final String pinFromSecureStorage =
          await secureStorage.read(key: SecureStorageKeys.PIN);
      if (pinFromSecureStorage == pinEntered) {
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> deletePin() async {
    try {
      await secureStorage.delete(key: SecureStorageKeys.PIN);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(SharedPreferencesKeys.IS_USER_PIN_SET);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> isUserPinSet() async {
    try {
      final String userPin =
          await secureStorage.read(key: SecureStorageKeys.PIN);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userPin.length > 0 &&
          prefs.getBool(SharedPreferencesKeys.IS_USER_PIN_SET)) {
        return true;
      }
      return false;
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

  Future<int> getBackgroundedTimestamp() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(SharedPreferencesKeys.BACKGROUNDED_TIMESTAMP);
    } catch (ex) {
      return 0;
    }
  }
}
