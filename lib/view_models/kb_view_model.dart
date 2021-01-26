import 'package:thepcosprotocol_app/models/knowledge_base.dart';

class KnowledgeBaseViewModel {
  final KnowledgeBase knowledgeBase;

  KnowledgeBaseViewModel({this.knowledgeBase});

  bool _isExpanded = false;

  int get knowledgeBaseId {
    return this.knowledgeBase.knowledgeBaseId;
  }

  String get question {
    return this.knowledgeBase.question;
  }

  String get answer {
    return this.knowledgeBase.answer;
  }

  bool get isExpanded {
    return this._isExpanded;
  }

  set isExpanded(final bool isExpanded) {
    this._isExpanded = isExpanded;
  }
}
