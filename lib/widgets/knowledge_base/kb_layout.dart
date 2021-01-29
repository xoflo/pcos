import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/cms_grouped_list_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/kb_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

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
    populateKBs();
  }

  List<String> getTagValues() {
    final stringContext = S.of(context);
    return <String>[
      stringContext.tagAll,
      stringContext.kbTagDiet,
      stringContext.kbTagEnergy,
      stringContext.kbTagExercise,
      stringContext.kbTagFertility,
      stringContext.kbTagHair,
      stringContext.kbTagInsulin,
      stringContext.kbTagSkin,
      stringContext.kbTagStress,
      stringContext.kbTagThyroid
    ];
  }

  void populateKBs() {
    debugPrint("**********************GETTING KBs**********************");
    Provider.of<CMSGroupedListViewModel>(context, listen: false)
        .getCMSGrouped("KnowledgeBase");
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

  Widget getKBList(Size screenSize, CMSGroupedListViewModel vm) {
    if (tagSelectedValue.length == 0) {
      tagSelectedValue = S.of(context).tagAll;
    }
    switch (vm.status) {
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
              tagValues: getTagValues(),
              tagValue: tagSelectedValue,
              onTagSelected: onTagSelected,
              onSearchClicked: onSearchClicked,
              isSearching: isSearching,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: KnowledgeBaseList(
                  screenSize: screenSize, knowledgeBases: vm.cmsGroupedItems),
            )
          ],
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CMSGroupedListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: getKBList(screenSize, vm),
      ),
    );
  }
}
