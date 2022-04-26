import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/onboarding/onboarding.dart';
import 'package:thepcosprotocol_app/widgets/onboarding/onboarding_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/ellipsis_painter.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/hollow_button.dart';
import 'package:thepcosprotocol_app/widgets/sign_in/register_web_view.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  static const id = "onboarding_page";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  final List<Onboarding> items = const [
    Onboarding(
      title: "Hello, we are Ovie",
      subtitle:
          "Do you want to finally reverse your PCOS symptoms? Then you need to fix the root of your PCOS.",
      asset: "assets/onboarding_1.png",
    ),
    Onboarding(
      title: "1:1 Consultation",
      subtitle:
          "Do you want to finally reverse your PCOS symptoms? Then you need to fix the root of your PCOS.",
      asset: "assets/onboarding_2.png",
    ),
    Onboarding(
      title: "Let’s personalise it.",
      subtitle:
          "Do you want to finally reverse your PCOS symptoms? Then you need to fix the root of your PCOS.",
      asset: "assets/onboarding_3.png",
    ),
  ];
  int _activePage = 0;

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

    return Scaffold(
      backgroundColor: onboardingBackground,
      body: Stack(
        children: [
          CustomPaint(
            painter: EllipsisPainter(
              color: primaryColor,
              heightMultiplier: 0.325,
              x1Multiplier: 0.75,
              y1Multiplier: 0.4,
              y2Multiplier: 0.25,
            ),
            child: Container(
              width: width,
              height: height,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    height: height * 0.5,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: items.length,
                      pageSnapping: true,
                      itemBuilder: (context, pagePosition) => OnboardingItem(
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
                  children: generateIndicators(),
                ),
                FilledButton(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 25,
                  ),
                  onPressed: () {
                    if (_activePage < 2) {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      setState(() {
                        _activePage = _activePage + 1;
                      });
                    } else {
                      Navigator.pushReplacementNamed(
                          context, RegisterWebView.id);
                    }
                  },
                  text: _activePage < 2 ? "NEXT" : "GET STARTED",
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
