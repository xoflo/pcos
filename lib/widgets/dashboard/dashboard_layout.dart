import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/course_lesson.dart';
import 'package:thepcosprotocol_app/screens/help.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/providers/course_question_provider.dart';

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  String _refreshToken = "";
  String _backgroundTimestamp = "";
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    getRefreshToken();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _offsetAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void getRefreshToken() async {
    final String token = await AuthenticationController().getRefreshToken();
    final int timeStamp =
        await AuthenticationController().getBackgroundedTimestamp();

    setState(() {
      _refreshToken = token;
      _backgroundTimestamp = timeStamp.toString();
    });
  }

  void _openLesson() async {
    await Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  void _closeLesson() async {
    _animationController.reverse();
  }

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
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox.expand(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: [
                    Text("RefreshToken=$_refreshToken"),
                    Text("BackgroundTimestamp=$_backgroundTimestamp"),
                    GestureDetector(
                      onTap: () {
                        _openLesson();
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color: secondaryColorLight,
                        size: 30,
                      ),
                    ),
                    Consumer<CourseQuestionProvider>(
                      builder: (context, courseQuestionModel, child) =>
                          Consumer<FAQProvider>(
                              builder: (context, faqModel, child) =>
                                  GestureDetector(
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
                                  )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SlideTransition(
          position: _offsetAnimation,
          child: CourseLesson(
            lessonId: 1,
            closeLesson: _closeLesson,
          ),
        ),
      ],
    );
  }
}
