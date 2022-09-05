import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_wiki_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_wiki_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class FavouritesWikis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    favouritesProvider.fetchLessonWikisStatus(notifyListener: false);

    return LoaderOverlay(
      indicatorPosition: Alignment.center,
      loadingStatusNotifier: favouritesProvider,
      height: double.maxFinite,
      emptyMessage: S.current.noFavouriteWikis,
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: favouritesProvider.lessonWikis.length,
        itemBuilder: (context, item) {
          final wiki = favouritesProvider.lessonWikis[item];

          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              LessonWikiPage.id,
              arguments: LessonWikiArguments(false, wiki),
            ).then((_) => favouritesProvider.fetchLessonWikisStatus()),
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
                    textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
                        height: 1.25, color: textColor.withOpacity(0.8)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
