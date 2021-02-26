import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/previous_lessons_navigator.dart';

class PreviousLessons extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final Function openLesson;
  final Function closeLesson;

  PreviousLessons({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.openLesson,
    @required this.closeLesson,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: screenSize.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Previous Lessons",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      PreviousLessonsNavigator(title: "Module", titleNumber: 2),
                      Text(
                        "Reducing Sugar",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8.0),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.92,
                        ),
                        items: [1, 2, 3, 4, 5].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Lesson $i",
                                      ),
                                      Text(
                                        "Afternoon Cravings",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "In the final lesson of the Reducing Sugar module we look at how you can avoid those afternoon snack cravings, and choose a healthier alternative.",
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("Listen now",
                                              style: TextStyle(
                                                  color: secondaryColorLight)),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Icon(
                                              Icons.volume_up,
                                              color: secondaryColorLight,
                                              size: 36,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
