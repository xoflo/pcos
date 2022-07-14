import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_task_page.dart';

class LessonTaskComponent extends StatelessWidget {
  const LessonTaskComponent({Key? key, required this.lessonTasks})
      : super(key: key);

  final List<LessonTask> lessonTasks;

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
                  "Tasks",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 20,
                  ),
                ),
                ...lessonTasks
                    .map(
                      (element) => GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          LessonTaskPage.id,
                          arguments: element,
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: HtmlWidget(
                                      element.title ?? "",
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  if (element.isComplete == true)
                                    Icon(
                                      Icons.check_circle,
                                      color: completedBackgroundColor,
                                      size: 32.5,
                                    )
                                  else
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: backgroundColor,
                                      size: 10,
                                    )
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
