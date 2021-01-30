import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/question_provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/kb_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/string_utils.dart';
import 'package:thepcosprotocol_app/models/question.dart';

class KnowledgeBaseLayout extends StatefulWidget {
  @override
  _KnowledgeBaseLayoutState createState() => _KnowledgeBaseLayoutState();
}

class _KnowledgeBaseLayoutState extends State<KnowledgeBaseLayout> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String tagSelectedValue = "";

  @override
  void initState() {
    super.initState();
  }

  void onTagSelected(String tagValue) {
    debugPrint("********************tagSelected=$tagValue");
    setState(() {
      tagSelectedValue = tagValue;
    });
  }

  void onSearchClicked() async {
    setState(() {
      isSearching = true;
    });
    //TODO: call search and remove delay
    await Future.delayed(const Duration(seconds: 3), () {});

    setState(() {
      isSearching = false;
    });
  }

  Widget getKBList(
      final Size screenSize, final QuestionProvider questionProvider) {
    //questionProvider.fetchAndSetData("KnowledgeBase");

    if (tagSelectedValue.length == 0) {
      tagSelectedValue = S.of(context).tagAll;
    }
    switch (questionProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        // TODO: create a widget for nothing found and test how it looks
        return Text("No items found!");
      case LoadingStatus.success:
        return Column(
          children: [
            SearchHeader(
              searchController: searchController,
              tagValues:
                  StringUtils.getTagValues(S.of(context), "knowledgebase"),
              tagValue: tagSelectedValue,
              onTagSelected: onTagSelected,
              onSearchClicked: onSearchClicked,
              isSearching: isSearching,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: KnowledgeBaseList(
                  screenSize: screenSize,
                  knowledgeBases: questionProvider.items),
            )
          ],
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<QuestionProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Consumer<QuestionProvider>(
      builder: (context, model, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: getKBList(screenSize, model),
        ),
      ),
    );
  }
}
