import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/task_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_task_bool.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_task_rating.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_task_text.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class LessonTaskPage extends StatefulWidget {
  const LessonTaskPage({Key? key}) : super(key: key);

  static const id = "lesson_task_page";

  @override
  State<LessonTaskPage> createState() => _LessonTaskPageState();
}

class _LessonTaskPageState extends State<LessonTaskPage> {
  Widget getTaskType(ModulesProvider modulesProvider, LessonTask task) {
    switch (task.taskType) {
      case TaskType.Text:
        return LessonTaskText(
          onSave: (text) =>
              onSubmit(modulesProvider, task.lessonID, task.lessonTaskID, text),
        );
      case TaskType.Rating:
        return LessonTaskRating(
          onSave: (rate) => onSubmit(modulesProvider, task.lessonID,
              task.lessonTaskID, rate.toString()),
        );
      case TaskType.Bool:
        return LessonTaskBool(
          onSave: (isTrue) => onSubmit(modulesProvider, task.lessonID,
              task.lessonTaskID, isTrue.toString()),
        );
      case TaskType.Okay:
        return FilledButton(
          onPressed: () => onSubmit(
              modulesProvider, task.lessonID, task.lessonTaskID, "Okay"),
          text: "Okay",
          margin: EdgeInsets.zero,
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor,
        );
      default:
        return Container();
    }
  }

  void onSubmit(ModulesProvider modulesProvider, int? lessonID, int? taskID,
      String value) {
    modulesProvider
        .setTaskAsComplete(taskID, value: value, lessonID: lessonID)
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)?.settings.arguments as LessonTask;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: "Lesson",
                  closeItem: () => Navigator.pop(context),
                ),
                Consumer<ModulesProvider>(
                  builder: (context, modulesProvider, child) {
                    switch (modulesProvider.status) {
                      case LoadingStatus.loading:
                        return Center(child: PcosLoadingSpinner());
                      case LoadingStatus.empty:
                        return NoResults(message: S.current.noItemsFound);
                      case LoadingStatus.success:
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HtmlWidget(
                                    task.description ?? "",
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  getTaskType(modulesProvider, task),
                                ],
                              ),
                            ),
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
