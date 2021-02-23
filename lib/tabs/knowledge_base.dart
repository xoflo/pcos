import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/kb_layout.dart';

class KnowledgeBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: KnowledgeBaseLayout(),
        ),
      ),
    );
    ;
  }
}
