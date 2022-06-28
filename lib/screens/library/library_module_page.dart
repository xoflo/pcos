import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LibraryModulePage extends StatefulWidget {
  const LibraryModulePage({Key? key}) : super(key: key);

  static const id = "library_previous_module_item";

  @override
  State<LibraryModulePage> createState() => _LibraryModulePageState();
}

class _LibraryModulePageState extends State<LibraryModulePage> {
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final lessons = ModalRoute.of(context)?.settings.arguments as List<Lesson>;
    final title = lessons.isNotEmpty
        ? modulesProvider.getModuleTitleByModuleID(lessons.first.moduleID)
        : "";
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: "Module Library",
                closeItem: () => Navigator.pop(context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 30,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 24,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];

                    final lessonContents =
                        modulesProvider.getLessonContent(lesson.lessonID);
                    final lessonTasks =
                        modulesProvider.getLessonTasks(lesson.lessonID);
                    final lessonWikis =
                        modulesProvider.getLessonWikis(lesson.lessonID);

                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        LessonPage.id,
                        arguments: LessonArguments(
                          lesson,
                          lessonContents,
                          lessonTasks,
                          lessonWikis,
                          showTasks: false,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: HtmlWidget(
                          lesson.title,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: backgroundColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}