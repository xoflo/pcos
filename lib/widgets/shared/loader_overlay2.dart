import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay({
    Key? key,
    required this.mainWidget,
  }) : super(key: key);

  final Widget mainWidget;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModulesProvider>(builder: (context, modulesProvider, child) => 
    Stack(
        children: <Widget>[
          mainWidget,
          modulesProvider.status != LoadingStatus.success
          ? Container(
            height: 530,
              // color: Colors.grey.withOpacity(0.5),
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.topCenter,
                    // child: CircularProgressIndicator(
                    //   backgroundColor: backgroundColor,
                    //   valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                child: CircularProgressIndicator(),
                  // ),
              ),
            )
          : Container()
        ],
      ));
  }
}
