import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/modules/previous_modules_carousel.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/messages/messages_list.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class PreviousModulesLayout extends StatefulWidget {
  final ModulesProvider modulesProvider;

  PreviousModulesLayout({
    @required this.modulesProvider,
  });
  @override
  _PreviousModulesLayoutState createState() => _PreviousModulesLayoutState();
}

class _PreviousModulesLayoutState extends State<PreviousModulesLayout> {
  int _selectedModuleID = 0;
  List<Lesson> _selectedModuleLessons = [];
  Lesson _selectedLesson;

  @override
  void initState() {
    super.initState();
    _setInitialModule();
  }

  Future<void> _setInitialModule() async {
    final Module initialModule = widget.modulesProvider
        .previousModules[widget.modulesProvider.previousModules.length - 1];
    final List<Lesson> initialLessons =
        await widget.modulesProvider.getModuleLessons(initialModule.moduleID);
    setState(() {
      _selectedModuleID = initialModule.moduleID;
      _selectedModuleLessons = initialLessons;
      _selectedLesson = initialLessons[initialLessons.length - 1];
    });
  }

  void _moduleChanged(final int index, final CarouselPageChangedReason reason) {
    debugPrint("index=$index reason=$reason");
  }

  void _addLessonToFavourites(dynamic lesson, bool add) {
    debugPrint("*********ADD LESSON TO FAVE");
  }

  void _openLesson(final Lesson lesson) async {
    openBottomSheet(
      context,
      CourseLesson(
        showDataUsageWarning: false,
        lesson: lesson,
        closeLesson: () {
          Navigator.pop(context);
        },
        addToFavourites: _addLessonToFavourites,
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      lesson.lessonID.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Consumer<ModulesProvider>(
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              title: S.of(context).previousModules,
              closeItem: () {
                Navigator.pop(context);
              },
              showMessagesIcon: false,
            ),
            _selectedModuleID == 0
                ? PcosLoadingSpinner()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        PreviousModulesCarousel(
                          screenSize: screenSize,
                          isHorizontal: isHorizontal,
                          modules: widget.modulesProvider.previousModules,
                          lessons: _selectedModuleLessons,
                          selectedModuleID: _selectedModuleID,
                          moduleChanged: _moduleChanged,
                          openLesson: _openLesson,
                        ),
                      ],
                    ),
                  ),
            //getPreviousModules(context, screenSize, isHorizontal, model),
          ],
        ),
      ),
    );
  }
}
