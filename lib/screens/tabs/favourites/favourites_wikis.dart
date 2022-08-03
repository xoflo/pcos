import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_wiki_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_wiki_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class FavouritesWikis extends StatefulWidget {
  const FavouritesWikis({Key? key, required this.favouritesProvider})
      : super(key: key);

  final FavouritesProvider favouritesProvider;

  @override
  State<FavouritesWikis> createState() => _FavouritesWikisState();
}

class _FavouritesWikisState extends State<FavouritesWikis> {
  @override
  void initState() {
    super.initState();

    widget.favouritesProvider.fetchLessonWikisStatus(notifyListener: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.favouritesProvider.lessonWikis.isEmpty) {
      return NoResults(message: S.current.noFavouriteWikis);
    }
    switch (widget.favouritesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noFavouriteWikis);
      case LoadingStatus.success:
        return ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: widget.favouritesProvider.lessonWikis.length,
          itemBuilder: (context, item) {
            final wiki = widget.favouritesProvider.lessonWikis[item];

            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                LessonWikiPage.id,
                arguments: LessonWikiArguments(false, wiki),
              ).then((_) => widget.favouritesProvider.fetchLessonWikisStatus()),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                      wiki.question ?? "",
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: backgroundColor),
                    ),
                    SizedBox(height: 10),
                    HtmlWidget(
                      "<p style='max-lines:2; text-overflow: ellipsis;'>" +
                          (wiki.answer ?? "") +
                          "</p>",
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(
                              height: 1.25, color: textColor.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
