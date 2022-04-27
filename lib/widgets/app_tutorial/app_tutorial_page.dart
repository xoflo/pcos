import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/app_tutorial/app_tutorial_get_started.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel_item_widget.dart';
import 'package:thepcosprotocol_app/widgets/shared/circle_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/ellipsis_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

class AppTutorialPage extends StatefulWidget {
  const AppTutorialPage({Key? key}) : super(key: key);

  static const id = "app_tutorial_page";

  @override
  State<AppTutorialPage> createState() => _AppTutorialPageState();
}

class _AppTutorialPageState extends State<AppTutorialPage> {
  final PageController _controller = PageController();
  int _activePage = 0;

  final List<CarouselItem> items = const [
    CarouselItem(
      title: "Welcome to our programme!",
      subtitle:
          "We tailored the programme to meet your specific needs using the information provided in the questionnaire.",
      asset: "assets/tutorial_1.png",
    ),
    CarouselItem(
      title: "Modules and lessons",
      subtitle:
          "It is important to take your time to complete all the modules and lessons in the programme.",
      asset: "assets/tutorial_2.png",
    ),
    CarouselItem(
      title: "Profile and Coach chat",
      subtitle:
          "Open ‘Profile’ for a summary of your type and symptoms. Remember 'Coach chat' to contact us for any support.",
      asset: "assets/tutorial_3.png",
    ),
    CarouselItem(
      title: "Course",
      subtitle:
          "Check ‘Course’ daily for your lessons and complete your tasks. ",
      asset: "assets/tutorial_4.png",
    ),
  ];

  List<Widget> generateIndicators() {
    return List<Widget>.generate(items.length, (index) {
      return Container(
          margin: const EdgeInsets.all(3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _activePage == index
                ? selectedIndicatorColor
                : unselectedIndicatorColor,
            shape: BoxShape.circle,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final bool showBackButton =
        (ModalRoute.of(context)?.settings.arguments as AppTutorialArguments)
            .showBackButton;

    CustomPainter? _getPainter() {
      switch (_activePage) {
        case 0:
          return EllipsisPainter(
            color: primaryColor,
            heightMultiplier: 0.475,
            x1Multiplier: 0.7,
            y1Multiplier: 0.55,
            y2Multiplier: 0.35,
          );
        case 4:
          return CirclePainter(
            color: primaryColor,
          );
        default:
          return null;
      }
    }

    return WillPopScope(
      onWillPop: () => Future.value(!Platform.isIOS && showBackButton),
      child: Scaffold(
        backgroundColor: primaryColorLight,
        body: Stack(
          children: [
            CustomPaint(
              painter: _getPainter(),
              child: Container(
                width: width,
                height: height,
              ),
            ),
            if (showBackButton)
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  leading: new IconButton(
                      icon: new Icon(
                        Icons.arrow_back,
                        color: backgroundColor,
                      ),
                      onPressed: () {
                        // We update the active page so that when popping,
                        // we remove the big ellipsis painted earlier
                        setState(() {
                          _activePage = _activePage + 1;
                        });

                        Navigator.of(context).pop();
                      }),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
              ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: height * 0.5,
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: items.length + 1,
                        pageSnapping: true,
                        itemBuilder: (context, pagePosition) =>
                            pagePosition == 4
                                ? AppTutorialGetStarted()
                                : CarouselItemWidget(
                                    item: items[pagePosition],
                                  ),
                        onPageChanged: (page) {
                          setState(() {
                            _activePage = page;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _activePage < 4
                        ? generateIndicators()
                        : [
                            Container(
                              margin: const EdgeInsets.all(8),
                            )
                          ],
                  ),
                  FilledButton(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 25,
                    ),
                    onPressed: () {
                      if (_activePage < 4) {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      } else {
                        Navigator.pop(context);
                      }

                      // We update the active page so that when popping,
                      // we remove the big ellipsis painted earlier
                      setState(() {
                        _activePage = _activePage + 1;
                      });
                    },
                    text: _activePage < 4 ? "NEXT" : "GET STARTED",
                    foregroundColor: Colors.white,
                    backgroundColor: backgroundColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
