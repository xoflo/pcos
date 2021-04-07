import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class CMSTextProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  CMSTextProvider({@required this.dbProvider}) {
    if (dbProvider != null) _fetchAndSaveData();
  }
  final String tableName = "CMSText";
  String _gettingStarted = "";
  String _privacyStatement = "";
  String _termsStatement = "";
  LoadingStatus status = LoadingStatus.empty;
  String get gettingStarted => _gettingStarted;
  String get privacyStatement => _privacyStatement;
  String get termsStatement => _termsStatement;

  Future<void> _fetchAndSaveData() async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    if (dbProvider.db != null) {
      //first get the data from the api if we have no data yet
      List<String> cmsItems =
          await ProviderHelper().fetchAndSaveCMSText(dbProvider, tableName);

      if (cmsItems.length > 0) _gettingStarted = cmsItems[0];
      if (cmsItems.length > 1) _privacyStatement = cmsItems[1];
      if (cmsItems.length > 2) _termsStatement = cmsItems[2];
    }

    status = LoadingStatus.success;
    notifyListeners();
  }
}
