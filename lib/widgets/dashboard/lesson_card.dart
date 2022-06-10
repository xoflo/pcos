import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonCard extends StatelessWidget {
  final int lessonNumber;
  final Lesson lesson;
  final bool isNew;
  final bool isSearch;
  final bool isPreviousModules;
  final FavouritesProvider favouritesProvider;
  final Function(Lesson) openLesson;
  final Function refreshPreviousModules;
  final ModulesProvider? modulesProvider;

  LessonCard({
    required this.lessonNumber,
    required this.lesson,
    required this.isNew,
    this.isSearch = false,
    this.isPreviousModules = false,
    required this.favouritesProvider,
    required this.openLesson,
    required this.refreshPreviousModules,
    this.modulesProvider,
  });

  void _onTap(final FavouritesProvider favouritesProvider) async {
    await favouritesProvider.addToFavourites(
        FavouriteType.Lesson, this.lesson.lessonID);

    if (this.isPreviousModules) {
      await this.refreshPreviousModules();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLessonComplete = this.lesson.isComplete;
    final Color cardColor = this.lesson.isToolkit
        ? altBackgroundColor
        : isLessonComplete || this.isNew
            ? backgroundColor
            : Colors.grey;
    return Consumer<FavouritesProvider>(
      builder: (context, favouritesProvider, child) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 32),
                        isSearch
                            ? Text(
                                modulesProvider?.getModuleTitleByModuleID(
                                        this.lesson.moduleID) ??
                                    "",
                                style: Theme.of(context).textTheme.headline6,
                              )
                            : Text(
                                "${S.current.lessonText} ${this.lessonNumber}",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                        this.lesson.isToolkit
                            ? Icon(Icons.construction,
                                size: 30, color: primaryColor)
                            : GestureDetector(
                                onTap: () {
                                  _onTap(favouritesProvider);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, right: 3.0),
                                  child: Icon(
                                    //TODO: DID we need this difference for is prev modules anymore?
                                    favouritesProvider.isFavourite(
                                            FavouriteType.Lesson,
                                            this.lesson.lessonID)
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: secondaryColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 56,
                      child: Center(
                        child: Text(
                          this.lesson.title,
                          textAlign: TextAlign.center,
                          style: isLessonComplete || this.isNew
                              ? Theme.of(context).textTheme.headline5
                              : Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.white70),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 0,
                      ),
                      child: SizedBox(
                        height: 106,
                        child: Center(
                          child: ClipRect(
                            child: HtmlWidget(this.lesson.introduction),
                          ),
                        ),
                      ),
                    ),
                    isLessonComplete || this.isNew
                        ? GestureDetector(
                            onTap: () {
                              this.openLesson(this.lesson);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(S.current.viewNow,
                                    style: TextStyle(color: secondaryColor)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.open_in_new,
                                    color: secondaryColor,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.black87,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
          !this.lesson.isComplete && this.isNew
              ? Align(
                  alignment: Alignment.topRight,
                  child: AvatarGlow(
                    glowColor: Colors.blue,
                    endRadius: 33.0,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 1000),
                    child: Material(
                      // Replace this child with your own
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Icon(
                          Icons.fiber_new,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        radius: 17.0,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
