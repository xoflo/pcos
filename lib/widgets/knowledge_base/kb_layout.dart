import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/string_utils.dart';

class KnowledgeBaseLayout extends StatefulWidget {
  @override
  _KnowledgeBaseLayoutState createState() => _KnowledgeBaseLayoutState();
}

class _KnowledgeBaseLayoutState extends State<KnowledgeBaseLayout> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String tagSelectedValue = "All";

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
    final questionProvider =
        Provider.of<KnowledgeBaseProvider>(context, listen: false);
    questionProvider.filterAndSearch(
        searchController.text.trim(), tagSelectedValue);
  }

  Widget getKBList(
      final Size screenSize, final KnowledgeBaseProvider kbProvider) {
    if (tagSelectedValue.length == 0) {
      tagSelectedValue = S.of(context).tagAll;
    }
    switch (kbProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        // TODO: create a widget for nothing found and test how it looks
        return Text("No items found!");
      case LoadingStatus.success:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child:
              QuestionList(screenSize: screenSize, questions: kbProvider.items),
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Consumer<KnowledgeBaseProvider>(
      builder: (context, model, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
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
              getKBList(screenSize, model),
            ],
          ),
        ),
      ),
    );
  }
}
