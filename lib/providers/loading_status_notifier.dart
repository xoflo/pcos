import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class LoadingStatusNotifier extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.loading;

  void setLoadingStatus(LoadingStatus newLoadingStatus, bool isNotify) {
    loadingStatus = newLoadingStatus;
    if(isNotify) notifyListeners();
  }
}
