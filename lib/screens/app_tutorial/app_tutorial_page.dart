import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/screens/tabs/app_tabs.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/app_tutorial/app_tutorial_get_started.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/base_carousel_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item_widget.dart';
import 'package:thepcosprotocol_app/widgets/shared/circle_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/ellipsis_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart' as Ovie;
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class AppTutorialPage extends StatelessWidget with BaseCarouselPage {
  AppTutorialPage({Key? key}) : super(key: key);

  static const id = "app_tutorial_page";

  @override
  int get itemsLength => items.length + 1;

  @override
  List<CarouselItem> get items => [
        CarouselItem(
          title: "Welcome to Ovie!",
          subtitle:
              "We tailored the programme to meet your specific needs using the information provided in the questionnaire.",
          asset: "assets/tutorial_1.png",
        ),
        CarouselItem(
          title: "Modules and lessons",
          subtitle:
              "Each module delivers lessons on a different topic, from breakfast, to sleep or exercise",
          asset: "assets/tutorial_2.png",
        ),
        CarouselItem(
          title: "Expert on hand",
          subtitle:
              "Our qualified PCOS experts are just one chat away, helping you with course content, motivation and support",
          asset: "assets/tutorial_3.png",
        ),
        CarouselItem(
          title: "Home",
          subtitle:
              "Check home daily to complete your lessons, quizzes, and tasks for each day",
          asset: "assets/tutorial_4.png",
        ),
        CarouselItem(
          title: "Notifications",
          subtitle:
              "Turn on Ovie app notifications in settings to allow for notifications for upcoming events, offers, new features, support and more",
          asset: "assets/tutorial_5.png",
        ),
      ];

  @override
  bool get isNotYetLastItem => activePage.value < 5;

  bool showBackButton(BuildContext context) {
    final bool showBackButton =
        (ModalRoute.of(context)?.settings.arguments as AppTutorialArguments)
            .showBackButton;
    return showBackButton;
  }

  @override
  CustomPainter? get painter {
    switch (activePage.value) {
      case 0:
        return EllipsisPainter(
          color: primaryColor,
          heightMultiplier: 0.475,
          x1Multiplier: 0.7,
          y1Multiplier: 0.55,
          y2Multiplier: 0.35,
        );
      case 5:
        return CirclePainter(
          color: primaryColor,
        );
      default:
        return null;
    }
  }

  @override
  Widget getItemBuilder(BuildContext context, int position) => position == 5
      ? AppTutorialGetStarted()
      : CarouselItemWidget(
          item: items[position],
        );

  @override
  Widget get indicator => ValueListenableBuilder<int>(
        valueListenable: activePage,
        builder: (context, value, child) => isNotYetLastItem
            ? super.indicator
            : Container(
                margin: const EdgeInsets.all(8),
              ),
      );

  @override
  List<Widget> getButtons(BuildContext context) {
    return [
      ValueListenableBuilder<int>(
        valueListenable: activePage,
        builder: (context, value, child) => Ovie.FilledButton(
          margin: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 25,
          ),
          onPressed: () {
            if (isNotYetLastItem) {
              controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            } else {
              PreferencesController()
                  .saveBool(SharedPreferencesKeys.VIEWED_TUTORIAL, true);
              Navigator.pushReplacementNamed(context, AppTabs.id);
            }

            // We update the active page so that when popping,
            // we remove the big ellipsis painted earlier
            updatePageValue(activePage.value + 1);
          },
          text: isNotYetLastItem ? "NEXT" : "GET STARTED",
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor,
        ),
      ),
    ];
  }
}
