import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class CarouselPageIndicator extends StatelessWidget {
  CarouselPageIndicator({Key? key, 
  required this.numberOfPages, 
  required this.activePage})
      : super(key: key);

  final ValueListenable<int> activePage;
  final int numberOfPages;

  List<Widget> generateIndicators() =>
      List<Widget>.generate(numberOfPages, (index) {
        return Container(
            margin: const EdgeInsets.all(3),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: activePage.value == index ? selectedIndicatorColor : unselectedIndicatorColor,
              shape: BoxShape.circle,
            ));
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generateIndicators(),
    );
  }
}
