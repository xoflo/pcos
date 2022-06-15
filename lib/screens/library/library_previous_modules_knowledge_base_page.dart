import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/library/library_previous_modules_knowledge_item.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class LibraryPreviousModulesKnowledgeBasePage extends StatefulWidget {
  const LibraryPreviousModulesKnowledgeBasePage({Key? key}) : super(key: key);

  static const id = "library_previous_modules_knowledge_base_page";

  @override
  State<LibraryPreviousModulesKnowledgeBasePage> createState() =>
      _LibraryPreviousModulesKnowledgeBasePageState();
}

class _LibraryPreviousModulesKnowledgeBasePageState
    extends State<LibraryPreviousModulesKnowledgeBasePage> {
  late ModulesProvider modulesProvider;
  late FavouritesProvider favouritesProvider;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
  }

  Widget getLoadingStatus() {
    switch (modulesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noItemsFound);
      case LoadingStatus.success:
        return Container();
    }
  }

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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (isPreviousModules
                              ? modulesProvider.previousModules
                              : modulesProvider.lessonWikis)
                          .map(
                            (item) => LibraryPreviousModulesKnowledgeItem(
                              modulesProvider: modulesProvider,
                              favouritesProvider: favouritesProvider,
                              item: item,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
