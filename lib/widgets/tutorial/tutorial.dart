import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class Tutorial extends StatelessWidget {
  final Function closeTutorial;

  Tutorial({this.closeTutorial});

  double _getTabBarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height - (kToolbarHeight + 20);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Container(
      height: _getTabBarHeight(context),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DialogHeader(
                screenSize: screenSize,
                favouriteType: FavouriteType.None,
                title: S.of(context).tutorialTitle,
                isFavourite: false,
                closeItem: closeTutorial,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: DeviceUtils.getRemainingHeight(
                      screenSize.height, false, isHorizontal, false, false),
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9,
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.amber),
                          child: Text(
                            'text $i',
                            style: TextStyle(fontSize: 16.0),
                          ));
                    },
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
