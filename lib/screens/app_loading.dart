import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_unlock.dart';
import 'package:thepcosprotocol_app/screens/authentication/sign_in.dart';
import 'package:thepcosprotocol_app/screens/unsupported_version.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class AppLoading extends StatefulWidget {
  static const String id = "app_loading_screen";

  @override
  _AppLoadingState createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  @override
  void initState() {
    super.initState();
    _appOpening();
  }

  Future<void> _appOpening() async {
    if (!await DeviceUtils.isVersionSupported()) {
      Navigator.pushReplacementNamed(context, UnsupportedVersion.id);
      return;
    } else {
      if (await AuthenticationController().isUserLoggedIn()) {
        if (await AuthenticationController().isUserPinSet()) {
          Navigator.pushNamed(
            context,
            PinUnlock.id,
            arguments: PinUnlockArguments(false),
          );
          return;
        }
      }
    }
    //navigate to relevant start up screen
    Navigator.pushReplacementNamed(context, SignIn.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: backgroundColor,
          valueColor: new AlwaysStoppedAnimation<Color>(primaryColorDark),
        ),
      ),
    );
  }
}
