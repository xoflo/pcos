import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial.dart';

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  @override
  void initState() {
    super.initState();
    checkShowTutorial();
  }

  Future<void> checkShowTutorial() async {
    if (!await PreferencesController().getViewedTutorial()) {
      PreferencesController().saveViewedTutorial();
      await Future.delayed(Duration(seconds: 2), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Tutorial(
            closeTutorial: () {
              Navigator.pop(context);
            },
          ),
        );
      });
    }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
