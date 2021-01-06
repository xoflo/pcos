import 'package:flutter/material.dart';

class KnowledgeBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text("Knowledge Base"),
          ),
        ),
      ),
    );
  }
}
