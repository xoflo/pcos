import 'package:thepcosprotocol_app/models/cms_grouped.dart';

class CMSGroupedViewModel {
  final CMSGrouped cmsGrouped;

  CMSGroupedViewModel({this.cmsGrouped});

  bool _isExpanded = false;

  String get question {
    return this.cmsGrouped.question;
  }

  String get answer {
    return this.cmsGrouped.answer;
  }

  bool get isExpanded {
    return this._isExpanded;
  }

  set isExpanded(final bool isExpanded) {
    this._isExpanded = isExpanded;
  }
}
