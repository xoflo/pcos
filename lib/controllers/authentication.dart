import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/constants/secure_storage_keys.dart'
    as SecureStorageKeys;
import 'package:thepcosprotocol_app/constants/exceptions.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Authentication {
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
        return true;
      }
    } catch (ex) {
      return false;
    }
    return false;
  }
}
