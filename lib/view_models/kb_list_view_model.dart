import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/view_models/kb_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class KnowledgeBaseListViewModel extends ChangeNotifier {
  List<KnowledgeBaseViewModel> kbs = List<KnowledgeBaseViewModel>();
  LoadingStatus status = LoadingStatus.empty;

  Future<void> getAllKBs() async {
    status = LoadingStatus.loading;
    final results = await WebServices().getAllKnowledgeBase();
    kbs = results
        .map((knowledgeBase) =>
            KnowledgeBaseViewModel(knowledgeBase: knowledgeBase))
        .toList();
    status = kbs.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }
}
