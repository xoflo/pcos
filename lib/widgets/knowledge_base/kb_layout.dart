import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/string_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

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

  void addFavourite(final FavouriteType favouriteType, final Question question,
      final bool add) async {
    debugPrint("*********ADD TO FAVE ADD=$add");
    final kbProvider =
        Provider.of<KnowledgeBaseProvider>(context, listen: false);
    await kbProvider.addToFavourites(question, add);
    //kbProvider.filterAndSearch(searchController.text.trim(), tagSelectedValue);
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
        return NoResults(message: S.of(context).noResultsKBs);
      case LoadingStatus.success:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: QuestionList(
            screenSize: screenSize,
            questions: kbProvider.items,
            showIcon: true,
            iconData: Icons.favorite_outline,
            iconDataOn: Icons.favorite,
            iconAction: addFavourite,
          ),
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
