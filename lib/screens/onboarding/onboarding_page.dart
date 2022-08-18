import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/base_carousel_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item_widget.dart';
import 'package:thepcosprotocol_app/widgets/shared/ellipsis_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';
import 'package:thepcosprotocol_app/screens/sign_in/register_web_view.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  static const id = "onboarding_page";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with BaseCarouselPage {
  List<CarouselItem> get items => [
        CarouselItem(
          title: "Hello, we are Ovie",
          subtitle:
              "Do you want to finally reverse your PCOS symptoms? Then you need to fix the root of your PCOS.",
          asset: "assets/onboarding_1.png",
        ),
        CarouselItem(
          title: "1:1 Consultation",
          subtitle:
              "Do you want to finally reverse your PCOS symptoms? Then you need to fix the root of your PCOS.",
          asset: "assets/onboarding_2.png",
        ),
        CarouselItem(
          title: "Let’s personalise it.",
          subtitle:
              "Do you want to finally reverse your PCOS symptoms? Then you need to fix the root of your PCOS.",
          asset: "assets/onboarding_3.png",
        ),
      ];

  @override
  int get itemsLength => items.length;

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
            setState(() {
              activePage = activePage + 1;
            });
          } else {
            Navigator.pushReplacementNamed(context, RegisterWebView.id);
          }
        },
        text: isNotYetLastItem ? "NEXT" : "GET STARTED",
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
      ),
      HollowButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, SignIn.id);
        },
        text: "I have done the questionnaire",
        style: OutlinedButton.styleFrom(
          primary: backgroundColor,
          backgroundColor: onboardingBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            width: 1,
            color: backgroundColor,
          ),
        ),
        margin: const EdgeInsets.all(15),
        verticalPadding: 5,
      )
    ];
  }

  @override
  Widget getItemBuilder(BuildContext context, int position) {
    return CarouselItemWidget(
      item: items[position],
    );
  }

  @override
  CustomPainter? getPainter() {
    return EllipsisPainter(
      color: primaryColor,
      heightMultiplier: 0.475,
      x1Multiplier: 1.5,
      y1Multiplier: 0.5,
      y2Multiplier: 0.1,
    );
  }

  @override
  bool get isNotYetLastItem => activePage < 2;

  @override
  bool get showBackButton => false;
}
