import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/cms_grouped_list_view_model.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/kb_layout.dart';

class KnowledgeBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CMSGroupedListViewModel(),
      child: KnowledgeBaseLayout(),
    );
  }
}
