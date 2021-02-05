import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';

class UnsupportedVersion extends StatelessWidget {
  void _openDialog(BuildContext context) {
    showAlertDialog(
        context,
        "App Store",
        "Please open the app store on your device, and upgrade The PCOS Protocol app.",
        "Okay",
        "",
        null);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColorDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderImage(screenSize: screenSize),
              SizedBox(height: 10.0),
              Text(
                "This version of The PCOS Protocol app is no longer supported.",
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              Text(
                "Please visit the app store to upgrade your app version.",
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  try {
                    LaunchReview.launch();
                    /*LaunchReview.launch(
                      androidAppId: "12345",
                      iOSAppId: "112345",
                      writeReview: false,
                    );*/
                  } catch (ex) {
                    _openDialog(context);
                  }
                },
                child: Image(
                  image: AssetImage('assets/images/app_store.png'),
                  height: 100.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
