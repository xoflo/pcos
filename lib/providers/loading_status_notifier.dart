import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class LoadingStatusNotifier extends ChangeNotifier {
  LoadingStatus _loadingStatus = LoadingStatus.loading;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoadingStatus(LoadingStatus newLoadingStatus, bool isNotify) {
    _loadingStatus = newLoadingStatus;
    if (isNotify) notifyListeners();
  }
}
