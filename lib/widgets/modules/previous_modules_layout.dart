import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/modules/previous_modules_carousel.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class PreviousModulesLayout extends StatefulWidget {
  final ModulesProvider modulesProvider;

  PreviousModulesLayout({
    required this.modulesProvider,
  });
  @override
  _PreviousModulesLayoutState createState() => _PreviousModulesLayoutState();
}

class _PreviousModulesLayoutState extends State<PreviousModulesLayout> {
  int _moduleIndex = 0;
  int _selectedModuleID = 0;
  List<Lesson> _selectedModuleLessons = [];
  List<List<Lesson>> _moduleLessons = [];
  CarouselController lessonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _setModuleDetails();
  }

  Future<void> _setModuleDetails() async {
    final Module initialModule = widget.modulesProvider.previousModules.last;
    final List<List<Lesson>> allLessons = [];

    for (Module module in widget.modulesProvider.previousModules) {
      allLessons.add(widget.modulesProvider.getModuleLessons(module.moduleID));
    }

    setState(() {
      _selectedModuleID = initialModule.moduleID ?? 0;
      _moduleLessons = allLessons;
      _selectedModuleLessons = allLessons.last;
      _moduleIndex = widget.modulesProvider.previousModules.length - 1;
    });
  }

  void _moduleChanged(final int index, final CarouselPageChangedReason reason) {
    final Module selectedModule = widget.modulesProvider.previousModules[index];
    setState(() {
      _moduleIndex = index;
      _selectedModuleID = selectedModule.moduleID ?? 0;
      _selectedModuleLessons = _moduleLessons[index];
      lessonCarouselController.jumpToPage(0);
    });
  }

  void _openLesson(final Lesson lesson) async {
    openBottomSheet(
      context,
      CourseLesson(
        modulesProvider: widget.modulesProvider,
        showDataUsageWarning: false,
        lesson: lesson,
        closeLesson: () {
          Navigator.pop(context);
        },
        lessonWikis: widget.modulesProvider.getLessonWikis(lesson.lessonID),
        lessonRecipes: widget.modulesProvider.getLessonRecipes(lesson.lessonID),
        getPreviousModuleLessons: _getPreviousModuleLessons,
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      lesson.lessonID.toString(),
    );
  }

  void _getPreviousModuleLessons() async {
    final List<List<Lesson>> allLessons = [];

    for (Module module in widget.modulesProvider.previousModules) {
      allLessons.add(widget.modulesProvider.getModuleLessons(module.moduleID));
    }

    setState(() {
      _moduleLessons = allLessons;
      _selectedModuleLessons = allLessons[_moduleIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: S.current.previousModules,
            closeItem: () {
              Navigator.pop(context);
            },
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
                        lessonCarouselController: lessonCarouselController,
                        moduleChanged: _moduleChanged,
                        openLesson: _openLesson,
                        refreshPreviousModules: _getPreviousModuleLessons,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
