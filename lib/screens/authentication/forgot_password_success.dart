import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart' as Ovie;

class ForgotPasswordSuccess extends StatelessWidget {
  const ForgotPasswordSuccess({Key? key}) : super(key: key);

  static const id = "forgot_password_success_page";

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Confirm your email",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(color: backgroundColor),
                ),
                SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(text: "We sent an email to "),
                      TextSpan(
                          text: "$email",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              ". Please check your email and click on the link to continue. Once you reset your password, you can sign in with your new password.")
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Ovie.FilledButton(
                  margin: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  text: S.current.signInTitle,
                  foregroundColor: Colors.white,
                  backgroundColor: backgroundColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
