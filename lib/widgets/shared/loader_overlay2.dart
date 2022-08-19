import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';

class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay({
    Key? key,
    required this.mainWidget,
    required this.loadingStatusNotifier,
  }) : super(key: key);

  final Widget mainWidget;
  final LoadingStatusNotifier loadingStatusNotifier;

  @override
  Widget build(BuildContext context) {
    // return Consumer<ModulesProvider>(builder: (context, modulesProvider, child) =>
    return Stack(
      children: <Widget>[
        mainWidget,
        loadingStatusNotifier.loadingStatus == LoadingStatus.loading
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

        // loadingStatusNotifier.loadingStatus == LoadingStatus.empty
        //     ? Container(
        //         height: 530,
        //         // color: Colors.grey.withOpacity(0.5),
        //         color: Colors.transparent,
        //         child: Align(
        //           alignment: Alignment.topCenter,
        //           // child: CircularProgressIndicator(
        //           //   backgroundColor: backgroundColor,
        //           //   valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
        //           child: CircularProgressIndicator(),
        //           // ),
        //         ),
        //       )
        //     : Container()

      ],
    );
  }
}
