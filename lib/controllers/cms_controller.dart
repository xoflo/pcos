import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class CmsController {
  Future<String> getCmsAsset(
      final String reference, final String tryAgainText) async {
    String sharedPrefKey = "${SharedPreferencesKeys.CMS_ASSET}_$reference";

    try {
      final String cmsAsset =
          await WebServices().getCmsAssetByReference(reference);

      if (cmsAsset != null && cmsAsset.length > 0) {
        //write it to storage async for future use
        saveCmsToStorage(sharedPrefKey, cmsAsset);
        return cmsAsset;
      } else {
        //try to get from storage?
        final String fromStorage = await getCmsFromStorage(sharedPrefKey);
        return fromStorage != null ? fromStorage : tryAgainText;
      }
    } catch (ex) {
      return await getCmsFromStorage(sharedPrefKey);
    }
  }

  Future<bool> saveCmsToStorage(
      final String preferenceName, final String cmsBody) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(preferenceName, cmsBody);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<String> getCmsFromStorage(final String preferenceName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(preferenceName);
    } catch (ex) {
      return "";
    }
  }
}
