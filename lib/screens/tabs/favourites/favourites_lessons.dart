import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class FavouritesLessons extends StatefulWidget {
  const FavouritesLessons({Key? key, required this.favouritesProvider})
      : super(key: key);

  final FavouritesProvider favouritesProvider;

  @override
  State<FavouritesLessons> createState() => _FavouritesLessonsState();
}

class _FavouritesLessonsState extends State<FavouritesLessons> {
  @override
  void initState() {
    super.initState();

    widget.favouritesProvider.fetchLessonStatus(notifyListener: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.favouritesProvider.lessons.isEmpty) {
      return NoResults(message: S.current.noFavouriteLesson);
    }
    switch (widget.favouritesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noFavouriteLesson);
      case LoadingStatus.success:
        return ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: widget.favouritesProvider.lessons.length,
          itemBuilder: (context, item) {
            final lesson = widget.favouritesProvider.lessons[item];

            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                LessonContentPage.id,
                arguments: lesson,
              ).then((_) => widget.favouritesProvider.fetchLessonStatus()),
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
        );
    }
  }
}
