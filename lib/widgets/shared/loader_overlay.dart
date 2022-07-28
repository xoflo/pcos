import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey.withOpacity(0.5),
        width: double.maxFinite,
        height: double.maxFinite,
        child: Center(child: PcosLoadingSpinner()),
      );
}
