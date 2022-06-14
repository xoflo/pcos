import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/library/library_previous_module_Item_lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LibraryPreviousModuleItem extends StatefulWidget {
  const LibraryPreviousModuleItem({Key? key}) : super(key: key);

  static const id = "library_previous_module_item";

  @override
  State<LibraryPreviousModuleItem> createState() =>
      _LibraryPreviousModuleItemState();
}

class _LibraryPreviousModuleItemState extends State<LibraryPreviousModuleItem> {
  late ModulesProvider modulesProvider;
  late FavouritesProvider favouritesProvider;
  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
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
                title: "Previous Modules",
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
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: LibraryPreviousModuleItemLesson(
                          favouritesProvider: favouritesProvider,
                          lesson: lesson,
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
