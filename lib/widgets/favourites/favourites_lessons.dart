import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_page.dart';
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
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
            final lessonContents =
                modulesProvider.getLessonContent(lesson.lessonID);
            final lessonWikis = modulesProvider.getLessonWikis(lesson.lessonID);
            final lessonTasks = modulesProvider.getLessonTasks(lesson.lessonID);
            final isFavouriteLesson = widget.favouritesProvider
                .isFavourite(FavouriteType.Lesson, lesson.lessonID);

            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                LessonPage.id,
                arguments: LessonArguments(
                  lesson,
                  lessonContents,
                  lessonTasks,
                  lessonWikis,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HtmlWidget(
                        lesson.title,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      onPressed: () {
                        widget.favouritesProvider.addToFavourites(
                          FavouriteType.Lesson,
                          lesson.lessonID,
                        );
                      },
                      icon: Icon(
                        isFavouriteLesson
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: redColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
