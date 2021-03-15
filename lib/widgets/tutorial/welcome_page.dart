import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class TutorialWelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Welcome to",
            style: Theme.of(context).textTheme.headline1,
          ),
          HeaderImage(
            screenSize: screenSize,
            isOrange: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Thank you for signing up to our programme. We are here to help you get the most from The PCOS Protocol.",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "We tailor the programme to meet your specific needs using the information provided in the questionnaire.",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "It is important to take your time to complete all the modules and lessons in the programme, beginning with the first module 'What is your Why?'.",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Also, when you feel you need our support, remember to tap the 'Coach Chat' to contact one of our friendly experts.",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Icon(
            Icons.chat_outlined,
            color: primaryColor,
            size: 30.0,
          )
        ],
      ),
    );
  }
}
