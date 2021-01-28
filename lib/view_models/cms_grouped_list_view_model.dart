import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/cms_grouped.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/view_models/cms_grouped_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class CMSGroupedListViewModel extends ChangeNotifier {
  List<CMSGroupedViewModel> cmsGroupedItems = List<CMSGroupedViewModel>();
  LoadingStatus status = LoadingStatus.empty;

  Future<void> getCMSGrouped(final String cmsType) async {
    status = LoadingStatus.loading;
    final results = await WebServices().getCMSByType(cmsType);
    cmsGroupedItems = convertToGroupedItems(results);
    status =
        cmsGroupedItems.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }

  List<CMSGroupedViewModel> convertToGroupedItems(List<CMS> cmsItems) {
    List<CMSGroupedViewModel> cmsGroupedList = List<CMSGroupedViewModel>();

    if (cmsItems.length.isOdd) {
      //an odd number of items, so remove the last one as they should be in pairs
      cmsItems.removeAt(cmsItems.length);
    }

    for (var i = 0; i < cmsItems.length - 1; i = i + 2) {
      final question = cmsItems[i];
      final answer = cmsItems[i + 1];
      debugPrint("question=${question.body}");
      debugPrint("answer=${answer.body}");
      final CMSGrouped cmsGrouped =
          CMSGrouped.fromStrings(question.body, answer.body);
      cmsGroupedList.add(CMSGroupedViewModel(cmsGrouped: cmsGrouped));
    }
    return cmsGroupedList;
  }
}
