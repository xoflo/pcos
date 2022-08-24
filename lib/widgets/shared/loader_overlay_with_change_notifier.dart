import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

/// A Widget that makes another widget overlayed with a progress indicator on top of it.
/// Purpose of which is to move out the logic behind the appearance/disappearance of
/// the progress indicator in the child widget into this LoadOverlay widget
/// Status of said child widget where the loader overlay will be applied must be provided
/// by a change notifier consumed by child widget. This change notifier must implement 
/// LoadingStatusNotifier.
/// The change notifier must have its own status attribute of type LoadingStatus and must
/// call setLoadingStatus(fetchAndSaveDataStatus, false); each time its status changes.
class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay(
      {Key? key,
      required this.child,
      required this.loadingStatusNotifier,
      required this.indicatorPosition,
      this.overlayBackgroundColor,
      required this.height})
      : super(key: key);

  final Widget child;
  final LoadingStatusNotifier loadingStatusNotifier;
  final Alignment indicatorPosition;
  final Color? overlayBackgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[child, _loaderOverlay()],
    );
  }

  Widget _loaderOverlay() {
    switch(loadingStatusNotifier.loadingStatus) {
      case LoadingStatus.loading: {
        return Container(
          height: height,
          color: overlayBackgroundColor ?? Colors.transparent,
          child: Align(
            alignment: indicatorPosition,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(backgroundColor),
            ),
          ),
        );
      }
      case LoadingStatus.empty: {
        return Center(child: NoResults(message: S.current.noResultsLessons));
      }
      case LoadingStatus.success: {
        return Container();
      }
    }
  }
}
