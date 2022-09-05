import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

// This is a loader overlay that does not use any providers. This is mostly
// used in states where the user is not currently in the main page (i.e. Forgot
// Password, Sign In, PIN loading, etc.)
class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(bottom: 30),
        color: Colors.grey.withOpacity(0.5),
        width: double.maxFinite,
        height: double.maxFinite,
        child: Center(child: PcosLoadingSpinner()),
      );
}
