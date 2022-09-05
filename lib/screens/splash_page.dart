import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/navigation/pin_unlock_arguments.dart';
import 'package:thepcosprotocol_app/screens/authentication/pin_unlock.dart';
import 'package:thepcosprotocol_app/screens/unsupported_version.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/screens/onboarding/onboarding_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_generic.dart';

class SplashPage extends StatefulWidget {
  static const String id = "splash_page";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLocked = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() => isLoading = true);
      _appOpening();
    });
  }

  Future<void> _appOpening() async {
    if (!await DeviceUtils.isVersionSupported()) {
      Navigator.pushReplacementNamed(context, UnsupportedVersion.id);
      return;
    } else {
      if (await AuthenticationController().isUserLoggedIn()) {
        if (await AuthenticationController().isUserPinSet() && !_isLocked) {
          Navigator.pushNamed(
            context,
            PinUnlock.id,
            arguments: PinUnlockArguments(false, _setIsLocked),
          );
          _setIsLocked(true);
          return;
        }
      }
    }
    //navigate to relevant start up screen
    Navigator.pushReplacementNamed(context, OnboardingPage.id);
  }

  void _setIsLocked(final bool isLocked) {
    setState(() {
      _isLocked = isLocked;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/logo_orange.png",
                height: 50,
                width: 125,
              ),
            ),
            if (isLoading) GenericLoaderOverlay()
          ],
        ),
      );
}
