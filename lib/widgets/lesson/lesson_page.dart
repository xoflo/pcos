import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_task_component.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  static const id = "lesson_page";

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as LessonArguments?;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
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
                        return PcosLoadingSpinner();
                      case LoadingStatus.empty:
                        return NoResults(message: S.current.noItemsFound);
                      case LoadingStatus.success:
                        final wikis = modulesProvider
                            .getLessonWikis(args?.lesson.lessonID ?? 0);
                        final contents = modulesProvider
                            .getLessonContent(args?.lesson.lessonID ?? 0);
                        final tasks = modulesProvider
                            .getLessonTasks(args?.lesson.lessonID ?? 0);

                        // A lesson can be completed if the lesson doesn't have
                        // any lesson tasks, or if the lesson has a task, and
                        // each one of the tasks is already completed.
                        // Otherwise, the user cannot proceed to the next lesson.
                        final isTaskComplete = tasks.isEmpty ||
                            (tasks.isNotEmpty &&
                                tasks.every(
                                    (element) => element.isComplete == true));
                        bool hasContents = false;

                        for (final content in contents) {
                          if (content.body?.isNotEmpty == true) {
                            hasContents = true;
                            break;
                          }
                        }

                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageComponent(
                                    imageUrl: args?.lesson.imageUrl ?? ""),
                                SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: HtmlWidget(
                                    args?.lesson.title ?? "",
                                    textStyle: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: HtmlWidget(
                                    args?.lesson.introduction ?? "",
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: textColor.withOpacity(0.8),
                                    ),
                                    isSelectable: true,
                                  ),
                                ),
                                if (hasContents) ...[
                                  SizedBox(height: 25),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: FilledButton(
                                      text: "LESSON PAGES",
                                      icon: Image(
                                        image: AssetImage(
                                            "assets/lesson_read_more.png"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      margin: EdgeInsets.zero,
                                      width: 200,
                                      isRoundedButton: false,
                                      foregroundColor: Colors.white,
                                      backgroundColor: backgroundColor,
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        LessonContentPage.id,
                                        arguments: args?.lesson,
                                      ),
                                    ),
                                  ),
                                ],
                                if (wikis.isNotEmpty == true)
                                  LessonWikiComponent(lessonWikis: wikis),
                                if (tasks.isNotEmpty == true &&
                                    args?.showTasks == true)
                                  LessonTaskComponent(lessonTasks: tasks),
                                if (args?.showTasks == true) ...[
                                  SizedBox(height: 30),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Divider(
                                      thickness: 1,
                                      height: 1,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: FilledButton(
                                      text: "Complete Lesson",
                                      icon: Icon(Icons.check_circle_outline),
                                      margin: EdgeInsets.zero,
                                      foregroundColor: Colors.white,
                                      backgroundColor: backgroundColor,
                                      onPressed: isTaskComplete
                                          ? () {
                                              final bool setModuleComplete =
                                                  modulesProvider
                                                          .currentModuleLessons
                                                          .last
                                                          .lessonID ==
                                                      args?.lesson.lessonID;

                                              modulesProvider
                                                  .setLessonAsComplete(
                                                    args?.lesson.lessonID ?? -1,
                                                    args?.lesson.moduleID ?? -1,
                                                    setModuleComplete,
                                                  )
                                                  .then((value) =>
                                                      Navigator.pop(context));
                                            }
                                          : null,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 40),
                              ],
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
