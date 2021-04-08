import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/task_card.dart';

class Tasks extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final ModulesProvider modulesProvider;

  Tasks({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.modulesProvider,
  });

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> with TickerProviderStateMixin {
  double _height = 240.0;
  bool _showSlider = true;
  Color _containerColor = Colors.white;

  void _onSubmit(final int taskID, final String value) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
                      widget.modulesProvider.displayLessonTasks.length - 1,
                ),
                items:
                    widget.modulesProvider.displayLessonTasks.map((lessonTask) {
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
    );
  }
}
