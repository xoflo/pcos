import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_wiki_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_page.dart';

class LessonWikiComponent extends StatelessWidget {
  const LessonWikiComponent({Key? key, required this.lessonWikis})
      : super(key: key);

  final List<LessonWiki> lessonWikis;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Wikis",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 20,
                  ),
                ),
                ...lessonWikis
                    .map(
                      (element) => GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          LessonWikiPage.id,
                          arguments: LessonWikiArguments(false, element),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HtmlWidget(
                                    element.question ?? "",
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: backgroundColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  HtmlWidget(
                                    "<p style='max-lines:2; text-overflow: ellipsis;'>" +
                                        (element.answer ?? "") +
                                        "</p>",
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: textColor.withOpacity(0.8),
                                      height: 1.25,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList()
              ],
            ),
          )
        ],
      );
}
