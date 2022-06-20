import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LessonPlanComponent extends StatelessWidget {
  const LessonPlanComponent({
    Key? key,
    required this.lessonContents,
    required this.lessonWikis,
    required this.lessonTasks,
  }) : super(key: key);

  final List<LessonContent> lessonContents;
  final List<LessonWiki> lessonWikis;
  final List<LessonTask> lessonTasks;

  @override
  Widget build(BuildContext context) {
    List<String> planTitles = [];

    if (lessonContents.isNotEmpty) {
      planTitles.add("Lesson Pages");
    }

    if (lessonWikis.isNotEmpty) {
      planTitles.add("Wikis");
    }
    if (lessonTasks.isNotEmpty) {
      planTitles.add("Tasks");
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(25),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lesson Plan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
          SizedBox(height: 15),
          ...planTitles.asMap().entries.map(
            (e) {
              final index = e.key;
              final value = e.value;
              return Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "${index + 1}. ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: value)
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
