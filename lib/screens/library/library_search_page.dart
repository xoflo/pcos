import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class LibrarySearchPage extends StatefulWidget {
  const LibrarySearchPage({Key? key}) : super(key: key);

  static const id = "library_search_page";

  @override
  State<LibrarySearchPage> createState() => _LibrarySearchPageState();
}

class _LibrarySearchPageState extends State<LibrarySearchPage> {
  final TextEditingController searchController = TextEditingController();

  bool isSearchFinished = false;
  bool isSearchDisabled = true;

  void search() async {
    final searchText = searchController.text.trim();
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
    await modulesProvider.filterAndSearch(searchText);
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: backgroundColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text("Search"),
          titleTextStyle: Theme.of(context).textTheme.headline5?.copyWith(
                color: backgroundColor,
              ),
          backgroundColor: primaryColorLight,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                width: double.maxFinite,
                color: primaryColorLight,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (_) => search(),
                        onChanged: (text) =>
                            setState(() => isSearchDisabled = text.isEmpty),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Opacity(
                              opacity: isSearchDisabled ? 0.5 : 1,
                              child: Icon(
                                Icons.search,
                                color: backgroundColor,
                                size: 20,
                              ),
                            ),
                            onPressed: isSearchDisabled ? null : search,
                          ),
                          hintText: "Search",
                          isDense: true,
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: !isSearchFinished
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          child: Text(
                            "Search any subjects, lessons or Wikis.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                    : Consumer<ModulesProvider>(
                        builder: (context, modulesProvider, child) {
                          switch (modulesProvider.searchStatus) {
                            case LoadingStatus.loading:
                              return PcosLoadingSpinner();
                            case LoadingStatus.empty:
                              return NoResults(
                                  message: S.current.noResultsLessonsSearch);
                            case LoadingStatus.success:
                              return ListView.builder(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                      child: HtmlWidget(
                                        searchLesson.title,
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: backgroundColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                          }
                        },
                      ),
              )
            ],
          ),
        ),
      );
}
