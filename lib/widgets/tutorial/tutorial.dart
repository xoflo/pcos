import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/tutorial_page.dart';
import 'package:thepcosprotocol_app/widgets/tutorial/welcome_page.dart';

class Tutorial extends StatefulWidget {
  final bool isStartUp;
  final Function closeTutorial;

  Tutorial({@required this.isStartUp, @required this.closeTutorial});

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  //final CarouselController _carouselController = CarouselController();
  bool _tutorialInitialised = false;
  List<Widget> _tutorialPages = [];
  int _currentPage = 0;
  bool _tutorialComplete = false;

  @override
  void initState() {
    super.initState();
    setTutorialPages();
  }

  Future<void> setTutorialPages() async {
    List<Widget> pages = [];
    if (widget.isStartUp) {
      pages.add(TutorialWelcomePage());
    }
    pages.add(TutorialPage(pageNumber: 1));
    pages.add(TutorialPage(pageNumber: 2));
    pages.add(TutorialPage(pageNumber: 3));
    pages.add(TutorialPage(pageNumber: 4));
    pages.add(TutorialPage(pageNumber: 5));

    setState(() {
      _tutorialPages.addAll(pages);
      _tutorialInitialised = true;
    });
  }

  Widget _getCarouselPager(final BuildContext context, final int totalPages) {
    List<Widget> circleList = [];
    for (var i = 0; i < totalPages; i++) {
      circleList.add(
        _drawCircle(
          i == _currentPage ? primaryColor : Colors.white,
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
    final totalPages = _tutorialPages.length;

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: !_tutorialInitialised
              ? Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: PcosLoadingSpinner(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: screenSize.height - 100,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          bool isTutorialComplete = false;
                          if (index == totalPages - 1 && !_tutorialComplete) {
                            analytics.logEvent(
                                name: Analytics
                                    .ANALYTICS_EVENT_TUTORIAL_COMPLETE);
                            isTutorialComplete = true;
                          }
                          setState(() {
                            _currentPage = index;
                            _tutorialComplete = isTutorialComplete;
                          });
                        },
                      ),
                      items: _tutorialPages.map((tutorialPage) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(color: Colors.white),
                              child: tutorialPage,
                            );
                          },
                        );
                      }).toList(),
                    ),
                    _getCarouselPager(context, totalPages),
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
