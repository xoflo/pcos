import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class CarouselPager extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final double bottomPadding;

  CarouselPager({
    required this.totalPages,
    required this.currentPage,
    required this.bottomPadding,
  });

  Widget _getCarouselPager(final BuildContext context) {
    List<Widget> circleList = [];
    for (var i = 0; i < totalPages; i++) {
      circleList.add(
        _drawCircle(
          i == currentPage ? primaryColor : Colors.white,
          i == currentPage ? 14 : 10,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: circleList,
    );
  }

  Widget _drawCircle(final Color color, final double size) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 6.0,
        bottom: bottomPadding,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: CircleAvatar(
          backgroundColor: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getCarouselPager(context);
  }
}
