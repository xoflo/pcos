import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/library/library_module_wiki_item.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class LibraryModuleWikiPage extends StatefulWidget {
  const LibraryModuleWikiPage({Key? key}) : super(key: key);

  static const id = "library_previous_modules_knowledge_base_page";

  @override
  State<LibraryModuleWikiPage> createState() => _LibraryModuleWikiPageState();
}

class _LibraryModuleWikiPageState extends State<LibraryModuleWikiPage> {
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
                title: "${isPreviousModules ? 'Module' : 'Wiki'} Library",
                closeItem: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: modulesProvider.previousModules.isEmpty
                        ? Center(
                            child: NoResults(
                              message:
                                  "No ${isPreviousModules ? 'modules' : 'wikis'} found",
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: modulesProvider.previousModules
                                .map(
                                  (item) => LibraryModuleWikiItem(
                                    modulesProvider: modulesProvider,
                                    favouritesProvider: favouritesProvider,
                                    item: item,
                                    isPreviousModules: isPreviousModules,
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
