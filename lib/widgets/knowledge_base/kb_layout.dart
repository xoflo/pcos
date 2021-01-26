import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/kb_list_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/kb_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';

class KnowledgeBaseLayout extends StatefulWidget {
  @override
  _KnowledgeBaseLayoutState createState() => _KnowledgeBaseLayoutState();
}

class _KnowledgeBaseLayoutState extends State<KnowledgeBaseLayout> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _populateKBs();
  }

  void _populateKBs() {
    debugPrint("**********************GETTING KBs**********************");
    Provider.of<KnowledgeBaseListViewModel>(context, listen: false).getAllKBs();
    debugPrint("KB****************** GOT THE KBs?");
  }

  Widget _getKBList(Size screenSize, KnowledgeBaseListViewModel vm) {
    switch (vm.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        // TODO: create a widget for nothing found and test how it looks
        return Text("No recipes found!");
      case LoadingStatus.success:
        return Column(
          children: [
            SearchHeader(
              searchController: searchController,
              isSearching: isSearching,
            ),
            KnowledgeBaseList(screenSize: screenSize, knowledgeBases: vm.kbs)
          ],
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<KnowledgeBaseListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: _getKBList(screenSize, vm),
    );
  }
}
