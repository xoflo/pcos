import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/screens/app_tabs.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/app_tutorial/app_tutorial_get_started.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/base_carousel_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item_widget.dart';
import 'package:thepcosprotocol_app/widgets/shared/circle_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/ellipsis_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class AppTutorialPage extends StatefulWidget {
  const AppTutorialPage({Key? key}) : super(key: key);

  static const id = "app_tutorial_page";

  @override
  State<AppTutorialPage> createState() => _AppTutorialPageState();
}

class _AppTutorialPageState extends State<AppTutorialPage>
    with BaseCarouselPage {
  @override
  List<CarouselItem> get items => [
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

  @override
  bool get isNotYetLastItem => activePage < 4;

  bool get showBackButton {
    final bool showBackButton =
        (ModalRoute.of(context)?.settings.arguments as AppTutorialArguments)
            .showBackButton;
    return showBackButton;
  }

  @override
  CustomPainter? getPainter() {
    switch (activePage) {
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

  @override
  Widget getItemBuilder(BuildContext context, int position) {
    return position == 4
        ? AppTutorialGetStarted()
        : CarouselItemWidget(
            item: items[position],
          );
  }

  @override
  List<Widget> generateIndicators() {
    return isNotYetLastItem
        ? super.generateIndicators()
        : [
            Container(
              margin: const EdgeInsets.all(8),
            )
          ];
  }

  @override
  List<Widget> getButtons() {
    return [
      FilledButton(
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
          setState(() {
            activePage = activePage + 1;
          });
        },
        text: isNotYetLastItem ? "NEXT" : "GET STARTED",
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
      ),
    ];
  }
}
