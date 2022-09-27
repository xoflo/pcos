import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header_image.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class UnsupportedVersion extends StatelessWidget {
  static const String id = "unsupported_version_screen";

  void _openDialog(BuildContext context) {
    showAlertDialog(
      context,
      S.current.versionDialogTitle,
      S.current.versionDialogDesc,
      S.current.okayText,
      "",
      null,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderImage(
                screenSize: screenSize,
                isOrange: true,
                verticalTopPadding: 80,
              ),
              SizedBox(height: 10.0),
              Text(
                S.current.versionText1,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: backgroundColor),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Icon(
                  Icons.sentiment_dissatisfied,
                  color: backgroundColor,
                  size: 60,
                ),
              ),
              Text(
                S.current.versionText2,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: backgroundColor),
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
