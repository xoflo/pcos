import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/secure_storage_keys.dart'
    as SecureStorageKeys;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class AuthenticationController {
  Future<bool> signIn(String emailOrUsername, String password) async {
    final token = await WebServices().signIn(emailOrUsername, password);

    if (token.accessToken.length > 0) {
      //save the username or email in secure storage so it can be used during change password process
      await secureStorage.write(
          key: SecureStorageKeys.EMAIL, value: token.profile.email);
      await secureStorage.write(
          key: SecureStorageKeys.USERNAME, value: token.profile.alias);
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

    return false;
  }

  Future<bool> refreshToken() async {
    try {
      final token = await WebServices().refreshToken();

      if (token.accessToken.length > 0) {
        //save the tokens to secure storage
        await secureStorage.write(
            key: SecureStorageKeys.ACCESS_TOKEN, value: token.accessToken);
        await secureStorage.write(
            key: SecureStorageKeys.REFRESH_TOKEN, value: token.refreshToken);
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
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

  Future<String> getUsername() async {
    try {
      final String username =
          await secureStorage.read(key: SecureStorageKeys.USERNAME);
      return username;
    } catch (ex) {
      return "";
    }
  }

  Future<String> getEmail() async {
    try {
      final String email =
          await secureStorage.read(key: SecureStorageKeys.EMAIL);
      return email;
    } catch (ex) {
      return "";
    }
  }

  Future<String> getUserId() async {
    try {
      final String email =
          await secureStorage.read(key: SecureStorageKeys.USER_ID);
      return email;
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
      final bool isRegistered =
          prefs.getBool(SharedPreferencesKeys.INTERCOM_REGISTERED);
      return isRegistered != null ? isRegistered : false;
    } catch (ex) {
      return false;
    }
  }
}