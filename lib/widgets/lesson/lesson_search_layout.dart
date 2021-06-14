import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/search_header.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_list.dart';

class LessonSearchLayout extends StatefulWidget {
  @override
  _LessonSearchLayoutState createState() => _LessonSearchLayoutState();
}

class _LessonSearchLayoutState extends State<LessonSearchLayout> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _hasSearchRun = false;

  void _addLessonToFavourites(
      final ModulesProvider modulesProvider, dynamic lesson, bool add) {
    modulesProvider.addToFavourites(lesson, add);
    //re-run the search to refresh data, and pick up the favourite change
    _refreshData();
  }

  void _openLesson(
      final Lesson lesson, final ModulesProvider modulesProvider) async {
    openBottomSheet(
      context,
      CourseLesson(
        modulesProvider: modulesProvider,
        showDataUsageWarning: false,
        lesson: lesson,
        closeLesson: () {
          Navigator.pop(context);
        },
        addToFavourites: _addLessonToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      lesson.lessonID.toString(),
    );
  }

  void _refreshData() async {
    //this is the add to favourite re-running the search to pickup the changes
    final String searchText = _searchController.text.trim();
    final modulesProvider =
        Provider.of<ModulesProvider>(context, listen: false);
    modulesProvider.filterAndSearch(searchText);
  }

  void _onSearchClicked() async {
    final String searchText = _searchController.text.trim();
    final modulesProvider =
        Provider.of<ModulesProvider>(context, listen: false);

    if (searchText.length == 0) {
      setState(() {
        _hasSearchRun = false;
      });
      modulesProvider.clearSearch();
    } else {
      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_SEARCH,
        parameters: {
          Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE:
              Analytics.ANALYTICS_SEARCH_LESSON,
          Analytics.ANALYTICS_PARAMETER_LESSON_SEARCH_TEXT: searchText
        },
      );
      setState(() {
        _hasSearchRun = true;
      });
      modulesProvider.filterAndSearch(searchText);
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    }
  }

  Widget _getLessonList(final ModulesProvider modulesProvider) {
    if (_hasSearchRun) {
      switch (modulesProvider.searchStatus) {
        case LoadingStatus.loading:
          return PcosLoadingSpinner();
        case LoadingStatus.empty:
          return NoResults(message: S.of(context).noResultsLessonsSearch);
        case LoadingStatus.success:
          return Column(
            children: [
              LessonList(
                  isComplete: true,
                  modulesProvider: modulesProvider,
                  openLesson: _openLesson),
              LessonList(
                  isComplete: false,
                  modulesProvider: modulesProvider,
                  openLesson: _openLesson),
            ],
          );
      }
    }
    return Container();
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
            title: S.of(context).lessonSearch,
            closeItem: () {
              Navigator.pop(context);
            },
            showMessagesIcon: false,
          ),
          Consumer<ModulesProvider>(
            builder: (context, model, child) => Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
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
                          ),
                          _getLessonList(model),
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
