import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/task_card.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';

class Tasks extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final ModulesProvider modulesProvider;
  final Function(String) updateWhatsYourWhy;

  Tasks({
    required this.screenSize,
    required this.isHorizontal,
    required this.modulesProvider,
    required this.updateWhatsYourWhy,
  });

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  double _height = 240.0;
  bool _showSlider = true;
  Color _containerColor = Colors.white;

  void _onSubmit(
      final int? taskID, final String value, final bool isYourWhy) async {
    final bool playAnimation =
        widget.modulesProvider.displayLessonTasks.length == 1;
    if (playAnimation) {
      setState(() {
        _showSlider = false;
      });
      await Future.delayed(const Duration(milliseconds: 100), () {});
      setState(() {
        _height = 0;
        _containerColor = Colors.white;
      });
    }
    await Future.delayed(const Duration(milliseconds: 750), () {});
    widget.modulesProvider.setTaskAsComplete(taskID, value);
    //if this is the whats your why and it hasn't already been set, set it now locally
    //backend updates the member whats your why automatically based on MetaName of the LessonTask
    final String whatsYourWhy = await PreferencesController()
        .getString(SharedPreferencesKeys.WHATS_YOUR_WHY);
    if (whatsYourWhy.length == 0 && isYourWhy) {
      //save to local storage
      await PreferencesController()
          .saveString(SharedPreferencesKeys.WHATS_YOUR_WHY, value);
      await PreferencesController()
          .saveBool(SharedPreferencesKeys.YOUR_WHY_DISPLAYED, true);
      widget.updateWhatsYourWhy(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.modulesProvider.status == LoadingStatus.success
        ? AnimatedContainer(
            duration: Duration(milliseconds: 750),
            curve: Curves.linear,
            width: widget.screenSize.width,
            height: _height,
            decoration: BoxDecoration(
              color: _containerColor,
            ),
            child: SizedBox(
              width: widget.screenSize.width,
              height: _height,
              child: _showSlider
                  ? CarouselSlider(
                      options: CarouselOptions(
                        height: _height,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.92,
                        initialPage:
                            widget.modulesProvider.displayLessonTasks.length -
                                1,
                      ),
                      items: widget.modulesProvider.displayLessonTasks
                          .map((lessonTask) {
                        return Builder(
                          builder: (BuildContext context) {
                            return TaskCard(
                              screenSize: widget.screenSize,
                              isHorizontal: widget.isHorizontal,
                              lessonTask: lessonTask,
                              onSubmit: _onSubmit,
                            );
                          },
                        );
                      }).toList(),
                    )
                  : Container(),
            ),
          )
        : Container();
  }
}
