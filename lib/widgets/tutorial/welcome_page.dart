import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class TutorialWelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    final double textPadding = isHorizontal ? 150 : 4;

    return SingleChildScrollView(
      child: SizedBox(
        height: screenSize.height - 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    S.current.tutorialWelcomeWelcome,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  HeaderImage(
                    screenSize: screenSize,
                    isOrange: true,
                    verticalTopPadding: 10,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: textPadding),
                child: Text(
                  S.current.tutorialWelcomeThankYou,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: textPadding),
                child: Text(
                  S.current.tutorialWelcomeTailor,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: textPadding),
                child: Text(
                  S.current.tutorialWelcomeModules,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.current.tutorialWelcomeCoachTitle,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          left: 10,
                        ),
                        child: Icon(
                          Icons.chat_outlined,
                          color: primaryColor,
                          size: isHorizontal ? 40.0 : 30.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: textPadding),
                    child: Text(
                      S.current.tutorialWelcomeCoachDesc,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
