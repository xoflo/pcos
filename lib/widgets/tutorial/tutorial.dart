import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

class Tutorial extends StatefulWidget {
  final Function closeTutorial;

  Tutorial({this.closeTutorial});

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  //final CarouselController _carouselController = CarouselController();
  int _currentPage = 0;
  final int _totalPages = 5;
  bool _tutorialComplete = false;

  double _getTabBarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height - (kToolbarHeight + 20);
  }

  Widget _getCarouselPager(final BuildContext context, final int totalPages) {
    List<Widget> circleList = new List<Widget>();
    for (var i = 0; i < totalPages; i++) {
      circleList.add(
        _drawCircle(
          i == _currentPage ? primaryColor : primaryColorLight,
          i == _currentPage ? 14 : 10,
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
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 6.0,
        bottom: 2.0,
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
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  height: screenSize.height - 100,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    bool isTutorialComplete = false;
                    if (index == _totalPages - 1 && !_tutorialComplete) {
                      analytics.logEvent(
                          name: Analytics.ANALYTICS_EVENT_TUTORIAL_COMPLETE);
                      isTutorialComplete = true;
                    }
                    setState(() {
                      _currentPage = index;
                      _tutorialComplete = isTutorialComplete;
                    });
                  },
                ),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Text(
                            'text $i',
                            style: TextStyle(fontSize: 16.0),
                          ));
                    },
                  );
                }).toList(),
              ),
              _getCarouselPager(context, _totalPages),
              ColorButton(
                isUpdating: false,
                label: "Close",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
