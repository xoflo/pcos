import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class LoadingStatusNotifier extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;
  // LoadingStatus get loadingStatus => _loadingStatus;

  // LoadingStatus status = LoadingStatus.empty;

  void setLoadingStatus(LoadingStatus newLoadingStatus, bool isNotify) {
    // _loadingStatus = newLoadingStatus;
    loadingStatus = newLoadingStatus;
    if(isNotify) notifyListeners();
  }
}
