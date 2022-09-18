import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class FavouritesLessons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    favouritesProvider.fetchLessonStatus(notifyListener: false);

    return LoaderOverlay(
      indicatorPosition: Alignment.center,
      loadingStatusNotifier: favouritesProvider,
      height: double.maxFinite,
      emptyMessage: S.current.noFavouriteLesson,
      overlayBackgroundColor: Colors.transparent,
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: favouritesProvider.lessons.length,
        itemBuilder: (context, item) {
          final lesson = favouritesProvider.lessons[item];

          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              LessonContentPage.id,
              arguments: lesson,
            ).then((_) => favouritesProvider.fetchLessonStatus()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: HtmlWidget(
                lesson.title,
                textStyle: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: backgroundColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
