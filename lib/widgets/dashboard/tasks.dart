import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/task_card.dart';

class Tasks extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final Function onSubmit;

  Tasks({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          width: screenSize.width,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 205,
              enableInfiniteScroll: false,
              viewportFraction: 0.92,
              initialPage: 5,
            ),
            items: [1].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  final isNew = i == 5 ? true : false;
                  return TaskCard(
                    screenSize: screenSize,
                    isHorizontal: isHorizontal,
                    onSubmit: onSubmit,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
