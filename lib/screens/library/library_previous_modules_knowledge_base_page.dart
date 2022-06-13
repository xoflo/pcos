import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LibraryPreviousModulesKnowledgeBasePage extends StatelessWidget {
  const LibraryPreviousModulesKnowledgeBasePage({Key? key}) : super(key: key);

  static const id = "library_previous_modules_knowledge_base_page";

  @override
  Widget build(BuildContext context) {
    final isPreviousModules =
        ModalRoute.of(context)?.settings.arguments as bool;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title:
                    isPreviousModules ? "Previous Modules" : "Knowledge Base",
                closeItem: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
