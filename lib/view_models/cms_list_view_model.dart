import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/view_models/cms_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class CMSListViewModel extends ChangeNotifier {
  List<CMSViewModel> cmsItems = List<CMSViewModel>();
  LoadingStatus status = LoadingStatus.empty;

  Future<void> getCMSByType(final String cmsType) async {
    status = LoadingStatus.loading;
    final results = await WebServices().getCMSByType(cmsType);
    cmsItems = results.map((cmsItem) => CMSViewModel(cms: cmsItem)).toList();
    status = cmsItems.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }
}
