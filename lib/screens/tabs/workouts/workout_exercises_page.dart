import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/models/workout_exercise.dart';
import 'package:thepcosprotocol_app/providers/workouts_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/carousel_page_indicator.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_component.dart';

class WorkoutExercisesPage extends StatelessWidget {
  static const id = "workout_exercises_page";

  final activePage = ValueNotifier(0);
  final isFavorite = ValueNotifier(false);

  List<Widget> getContentUrlType(WorkoutExercise? workoutExercise) {
    return [
      SizedBox(height: 20),
      VideoComponent(videoUrl: workoutExercise?.mediaUrl ?? "")
    ];
  }

  @override
  Widget build(BuildContext context) {
    final workoutsProvider =
        Provider.of<WorkoutsProvider>(context);

    final pageController = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: SafeArea(
          bottom: false,
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
                    title: "Workout Pages",
                    closeItem: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: workoutsProvider.workoutExercises.length,
                      pageSnapping: true,
                      onPageChanged: (page) => activePage.value = page,
                      itemBuilder: (context, index) {
                        final content =
                            workoutsProvider.workoutExercises[index];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                HtmlWidget(
                                  content.title ?? "",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(color: backgroundColor),
                                ),
                                SizedBox(height: 20),
                                HtmlWidget(
                                  content.description ?? "",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        color: textColor.withOpacity(0.8),
                                        height: 1.5,
                                      ),
                                ),
                                ...getContentUrlType(content),
                                SizedBox(height: 30),
                                Text(
                                  'Sets: ${content.setsMinimum} - ${content.setsMaximum}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(height: 18),
                                Text(
                                  'Repetitions: ${content.repsMinimum} - ${content.repsMaximum}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(height: 18),
                                Text(
                                  'Equipment: ${content.equipmentRequired}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (workoutsProvider.workoutExercises.length  > 1) ...[
                    SizedBox(height: 20),
                    ValueListenableBuilder<int>(
                      valueListenable: activePage,
                      builder: (context, value, child) => CarouselPageIndicator(
                        numberOfPages: workoutsProvider.workoutExercises.length,
                        activePage: activePage,
                      ),
                    )
                  ],
                  SizedBox(height: 75)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
