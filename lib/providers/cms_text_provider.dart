import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class CMSTextProvider with ChangeNotifier {
  final DatabaseProvider? dbProvider;

  CMSTextProvider({required this.dbProvider}) {
    if (dbProvider != null) fetchAndSaveData();
  }
  String _gettingStarted = "";
  String _privacyStatement = "";
  String _termsStatement = "";
  LoadingStatus status = LoadingStatus.empty;
  String get gettingStarted => _gettingStarted;
  String get privacyStatement => _privacyStatement;
  String get termsStatement => _termsStatement;

  Future<void> fetchAndSaveData() async {
    status = LoadingStatus.loading;

    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on integration_test.dart)
    if (dbProvider?.db != null) {
      //first get the data from the api if we have no data yet
      List<String> cmsItems =
          await ProviderHelper().fetchAndSaveCMSText(dbProvider);

      if (cmsItems.length > 0) _gettingStarted = cmsItems[0];
      if (cmsItems.length > 1) _privacyStatement = cmsItems[1];
      if (cmsItems.length > 2) _termsStatement = cmsItems[2];
    }

    status = LoadingStatus.success;
  }
}
