import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class WikiSearchLayout extends StatefulWidget {
  @override
  _WikiSearchLayoutState createState() => _WikiSearchLayoutState();
}

class _WikiSearchLayoutState extends State<WikiSearchLayout> {
  final TextEditingController _searchController = TextEditingController();
  int _moduleID = 0;
  String _moduleTitle = S.current.allModules;
  bool _isSearching = false;
  bool _hasSearchRun = false;
  List<LessonWiki> _lessonWikis = [];

  void _onSearchClicked() async {
    final String searchText = _searchController.text.trim();
    final modulesProvider =
        Provider.of<ModulesProvider>(context, listen: false);

    if (searchText.length == 0 && _moduleID == 0) {
      setState(() {
        _lessonWikis = [];
        _hasSearchRun = false;
      });
    } else {
      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_SEARCH,
        parameters: {
          Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE:
              Analytics.ANALYTICS_SEARCH_LESSON_WIKI,
          Analytics.ANALYTICS_PARAMETER_LESSON_SEARCH_TEXT: searchText
        },
      );
      final List<LessonWiki> lessonWikis = await modulesProvider
          .searchLessonWikis(_moduleID, _searchController.text.trim());
      setState(() {
        _lessonWikis = lessonWikis;
        _hasSearchRun = true;
      });
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    }
  }

  void _onModuleSelected(final String moduleIDString) {
    final int moduleID = int.parse(moduleIDString);
    final String moduleTitle = S.current.allModules;

    if (moduleID > 0) {
      final modulesProvider =
          Provider.of<ModulesProvider>(context, listen: false);
      _moduleTitle = modulesProvider.getModuleTitleByModuleID(moduleID);
    }

    setState(() {
      _moduleID = moduleID;
      _moduleTitle = moduleTitle;
    });

    _onSearchClicked();
  }

  void _addToFavourites(
      FavouriteType favouriteType, final dynamic item, final bool add) async {
    Provider.of<FavouritesProvider>(context, listen: false)
        .addToFavourites(FavouriteType.Wiki, item.quesionId);
    _onSearchClicked();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: S.current.searchWiki,
            closeItem: () {
              Navigator.pop(context);
            },
            showMessagesIcon: false,
          ),
          Consumer<ModulesProvider>(
            builder: (context, model, child) => Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  List<Module> allModules = model.allModules;
                  Module emptyModule =
                      Module(moduleID: 0, title: S.current.allModules);
                  allModules.insert(0, emptyModule);
                  return Container(
                    height: constraints.maxHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SearchHeader(
                            formKey: _formKey,
                            searchController: _searchController,
                            tagValues: [],
                            tagValueSelected: "",
                            onTagSelected: (String tagValue) {},
                            onSearchClicked: _onSearchClicked,
                            isSearching: _isSearching,
                            modules: allModules,
                            selectedModule: _moduleID,
                            selectedModuleTitle: _moduleTitle,
                            onModuleSelected: _onModuleSelected,
                          ),
                          _lessonWikis.length > 0
                              ? QuestionList(
                                  questions: [],
                                  wikis: _lessonWikis,
                                  showIcon: true,
                                  iconData: Icons.favorite_outline,
                                  iconDataOn: Icons.favorite,
                                  iconAction: _addToFavourites,
                                )
                              : _hasSearchRun
                                  ? NoResults(message: S.current.noWikisSearch)
                                  : Container(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
