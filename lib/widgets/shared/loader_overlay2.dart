import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay(
      {Key? key,
      required this.mainWidget,
      required this.loadingStatusNotifier,
      required this.indicatorPosition,
      this.overlayBackgroundColor,
      required this.height})
      : super(key: key);

  final Widget mainWidget;
  final LoadingStatusNotifier loadingStatusNotifier;
  final Alignment indicatorPosition;
  final Color? overlayBackgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[mainWidget, _loaderOverlay()],
    );
  }

  Widget _loaderOverlay() {
    if (loadingStatusNotifier.loadingStatus == LoadingStatus.loading) {
      return Container(
        height: height,
        color: overlayBackgroundColor ?? Colors.transparent,
        child: Align(
          alignment: indicatorPosition,
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(backgroundColor),
            // child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (loadingStatusNotifier.loadingStatus == LoadingStatus.empty) {
      return Center(child: NoResults(message: S.current.noResultsLessons));
    } else {
      return Container();
    }
  }
}
