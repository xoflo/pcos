import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_wiki_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/lesson_wiki_page.dart';

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
                  style: Theme.of(context).textTheme.headline4,
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
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(color: backgroundColor),
                                  ),
                                  SizedBox(height: 10),
                                  HtmlWidget(
                                    "<p style='max-lines:2; text-overflow: ellipsis;'>" +
                                        ((element.answer ?? "").length > 200
                                            ? (element.answer ?? "")
                                                .substring(0, 200)
                                            : (element.answer ?? "")) +
                                        "</p>",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(
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
