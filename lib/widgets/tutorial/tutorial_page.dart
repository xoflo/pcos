import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/utils/drawing_utils.dart';

class TutorialPage extends StatelessWidget {
  final int pageNumber;

  TutorialPage({required this.pageNumber});

  Widget getPageContent(final BuildContext context, final Size screenSize,
      final bool isHorizontal) {
    switch (pageNumber) {
      case 1:
        return getPageOne(context, screenSize, isHorizontal);
      case 2:
        return getPageTwo(context, screenSize, isHorizontal);
      case 3:
        return getPageThree(context, screenSize, isHorizontal);
      case 4:
        return getPageFour(context, screenSize, isHorizontal);
      case 5:
        return getPageFive(context, screenSize, isHorizontal);
    }
    return Container();
  }

  Widget getPageOne(final BuildContext context, final Size screenSize,
      final bool isHorizontal) {
    return SingleChildScrollView(
      child: SizedBox(
        height: screenSize.height - 77,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isHorizontal ? 50 : 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  S.current.tutorialNavigationHeaderBar,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: isHorizontal ? (screenSize.width / 2) : 70.0,
                  bottom: 20,
                ),
                child: Text(
                  S.current.tutorialNavigationDrawerMenu,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.justify,
                ),
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: backgroundColor),
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.menu,
                            color: primaryColor,
                            size: 26.0,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.chat_outlined,
                                  color: primaryColor,
                                  size: 26.0,
                                ),
                              ),
                              Icon(
                                Icons.notifications_none,
                                color: primaryColor,
                                size: 26.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 30),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: CustomPaint(
                        painter: DrawCircle(
                          circleColor: primaryColor,
                          isFilled: false,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3, top: 30),
                      child: Container(
                        width: 40,
                        height: 40,
                        child: CustomPaint(
                          painter: DrawCircle(
                            circleColor: primaryColor,
                            isFilled: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: isHorizontal ? (screenSize.width / 2) : 80.0,
                    top: 20),
                child: Text(
                  S.current.tutorialNavigationNotifications,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  S.current.tutorialNavigationBottomTabs,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.tutorialNavigationYourCourse,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(""),
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Text(
                        S.current.tutorialNavigationRecipes,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Text(""),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(color: primaryColor),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.batch_prediction,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.local_dining,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      S.current.tutorialNavigationKB,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Text(""),
                  Text(
                    S.current.tutorialNavigationFaves,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPageTwo(final BuildContext context, final Size screenSize,
      final bool isHorizontal) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          S.current.tutorialYourCourseTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      Icon(
        Icons.school,
        size: 70,
        color: primaryColor,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          S.current.tutorialYourCourseDesc,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  Widget getPageThree(final BuildContext context, final Size screenSize,
      final bool isHorizontal) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          S.current.tutorialKBTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      Icon(
        Icons.batch_prediction,
        size: 70,
        color: primaryColor,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          S.current.tutorialKBDesc,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  Widget getPageFour(final BuildContext context, final Size screenSize,
      final bool isHorizontal) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          S.current.tutorialRecipesTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      Icon(
        Icons.local_dining,
        size: 70,
        color: primaryColor,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          S.current.tutorialRecipesDesc,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  Widget getPageFive(final BuildContext context, final Size screenSize,
      final bool isHorizontal) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          S.current.tutorialFavesTitle,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      Icon(
        Icons.favorite_outline,
        size: 70,
        color: primaryColor,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          S.current.tutorialFavesDesc,
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: getPageContent(context, screenSize, isHorizontal),
    );
  }
}
