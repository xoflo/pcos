import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/search_component.dart';

class LibrarySearchPage extends StatefulWidget {
  const LibrarySearchPage({Key? key}) : super(key: key);

  static const id = "library_search_page";

  @override
  State<LibrarySearchPage> createState() => _LibrarySearchPageState();
}

class _LibrarySearchPageState extends State<LibrarySearchPage> {
  final TextEditingController searchController = TextEditingController();

  String? searchText;

  bool isSearchFinished = false;
  bool isSearchDisabled = true;

  void search() async {
    final searchText = searchController.text.trim();
    if (searchText.isNotEmpty) {
      final modulesProvider =
          Provider.of<ModulesProvider>(context, listen: false);

      analytics.logEvent(
        name: Analytics.ANALYTICS_EVENT_SEARCH,
        parameters: {
          Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE:
              Analytics.ANALYTICS_SEARCH_LESSON,
          Analytics.ANALYTICS_PARAMETER_LESSON_SEARCH_TEXT: searchText
        },
      );
      setState(() => isSearchFinished = true);
      await modulesProvider.filterAndSearch(searchText).then((_) async =>
          await PreferencesController()
              .addToStringList(SEARCH_ITEMS, searchText));
    } else {
      setState(() => isSearchFinished = false);
    }
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String?;

    if (searchText == null && args != null && args.isNotEmpty) {
      searchText = args;
      searchController.text = args;
      isSearchDisabled = false;
      search();
    }

    final modulesProvider = Provider.of<ModulesProvider>(context);

    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: backgroundColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text("Search"),
          titleTextStyle:
              Theme.of(context).textTheme.bodyText1?.copyWith(color: textColor),
          backgroundColor: primaryColorLight,
          elevation: 0.0,
        ),
        body: WillPopScope(
          onWillPop: () async => !Platform.isIOS,
          child: SafeArea(
            child: Column(
              children: [
                SearchComponent(
                  searchController: searchController,
                  searchBackgroundColor: primaryColorLight,
                  onSearchPressed: search,
                ),
                Expanded(
                  child: !isSearchFinished
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: Text(
                              "Search any subjects, lessons or Wikis.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: textColor.withOpacity(0.5)),
                            ),
                          ),
                        )
                      : LoaderOverlay(
                          child: ListView.builder(
                            padding: EdgeInsets.all(15),
                            itemCount: modulesProvider.searchLessons.length,
                            itemBuilder: (context, index) {
                              final searchLesson =
                                  modulesProvider.searchLessons[index];

                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  LessonContentPage.id,
                                  arguments: searchLesson,
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: HtmlWidget(
                                    searchLesson.title,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(color: backgroundColor),
                                  ),
                                ),
                              );
                            },
                          ),
                          loadingStatusNotifier: modulesProvider,
                          indicatorPosition: Alignment.center,
                          height: double.maxFinite,
                          emptyMessage: S.current.noResultsLessonsSearch,
                          overlayBackgroundColor: Colors.transparent,
                        ),
                )
              ],
            ),
          ),
        ));
  }
}
