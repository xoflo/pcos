import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thepcosprotocol_app/constants/app_state.dart';
import 'package:thepcosprotocol_app/widgets/auth/register_layout.dart';
import 'package:thepcosprotocol_app/widgets/auth/open_sign_up.dart';
import 'package:thepcosprotocol_app/widgets/auth/email_sign_up.dart';
import 'package:thepcosprotocol_app/widgets/auth/goto_sign_in.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/utils/error_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class Register extends StatefulWidget {
  final Function(AppState) updateAppState;

  Register({this.updateAppState});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();

  void openQuestionnaireWebsite() async {
    debugPrint("open website");
    final urlQuestionnaireWebsite =
        FlavorConfig.instance.values.questionnaireUrl;
    if (await canLaunch(urlQuestionnaireWebsite)) {
      await launch(
        urlQuestionnaireWebsite,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      showFlushBar(
          context,
          S.of(context).questionnaireWebsiteErrorTitle,
          S
              .of(context)
              .questionnaireWebsiteErrorText
              .replaceAll("[url]", urlQuestionnaireWebsite),
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColorDark);
    }
  }

  void emailQuestionnaireWebsiteLink() {
    debugPrint("email link to ${emailController.text}");
  }

  void navigateToSignIn() {
    debugPrint("signin");
    widget.updateAppState(AppState.SIGN_IN);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: RegisterLayout(
        isHorizontal: DeviceUtils.isHorizontalWideScreen(
            screenSize.width, screenSize.height),
        screenSize: screenSize,
        openSignUp: OpenSignUp(openWebsite: openQuestionnaireWebsite),
        emailSignUp: EmailSignIn(
          emailWebsiteLink: emailQuestionnaireWebsiteLink,
          emailController: emailController,
        ),
        gotoSignIn: GotoSignIn(navigateToSignIn: navigateToSignIn),
      ),
    );
  }
}