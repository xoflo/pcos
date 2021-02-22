import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
import 'package:thepcosprotocol_app/screens/help.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/providers/course_question_provider.dart';

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  @override
  void initState() {
    super.initState();
  }

  void openLesson() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CourseLesson(
        lesson: Lesson(),
        closeLesson: closeLesson,
        addToFavourites: addToFavourites,
      ),
    );
  }

  void closeLesson() async {
    Navigator.pop(context);
  }

  void addToFavourites(dynamic lesson, bool add) {}

  void _openHelp(
      BuildContext context, final faqProvider, final courseQuestionProvider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Help(
          closeMenuItem: closeHelp,
          faqProvider: faqProvider,
          courseQuestionProvider: courseQuestionProvider,
        ),
      ),
    );
  }

  void closeHelp() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Watch your latest lesson now."),
                    GestureDetector(
                      onTap: () {
                        openLesson();
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color: secondaryColorLight,
                        size: 48,
                      ),
                    ),
                  ],
                ),
                Consumer<CourseQuestionProvider>(
                  builder: (context, courseQuestionModel, child) =>
                      Consumer<FAQProvider>(
                    builder: (context, faqModel, child) => Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _openHelp(
                              context,
                              faqModel,
                              courseQuestionModel,
                            );
                          },
                          child: Icon(
                            Icons.help,
                            color: secondaryColorLight,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
