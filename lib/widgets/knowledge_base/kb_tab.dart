import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/string_utils.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class KnowledgeBaseTab extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final KnowledgeBaseProvider knowledgeBaseProvider;

  KnowledgeBaseTab({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.knowledgeBaseProvider,
  });

  @override
  _KnowledgeBaseTabState createState() => _KnowledgeBaseTabState();
}

class _KnowledgeBaseTabState extends State<KnowledgeBaseTab> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String tagSelectedValue = "All";

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

  void onTagSelected(String tagValue) {
    setState(() {
      tagSelectedValue = tagValue;
    });
    onSearchClicked();
  }

  void onSearchClicked() async {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_SEARCH,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE: Analytics.ANALYTICS_SEARCH_KB
      },
    );
    widget.knowledgeBaseProvider
        .filterAndSearch(searchController.text.trim(), tagSelectedValue);
  }

  void addFavourite(final FavouriteType favouriteType, final Question question,
      final bool add) async {
    await widget.knowledgeBaseProvider.addToFavourites(question, add);
    await widget.knowledgeBaseProvider.refreshFavourites(true, true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchHeader(
            searchController: searchController,
            tagValues: StringUtils.getTagValues(S.of(context), "knowledgebase"),
            tagValue: tagSelectedValue,
            onTagSelected: onTagSelected,
            onSearchClicked: onSearchClicked,
            isSearching: isSearching,
          ),
          getKBList(widget.screenSize, widget.knowledgeBaseProvider),
        ],
      ),
    );
  }
}
