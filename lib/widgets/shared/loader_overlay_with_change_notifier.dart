import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
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
  LoaderOverlay({
    Key? key,
    required this.child,
    required this.loadingStatusNotifier,
    required this.indicatorPosition,
    this.overlayBackgroundColor,
    required this.height,
    this.emptyMessage = "",
    this.isDisplayErrorAsAlert = true,
    this.isErrorDialogDismissible = true,
    this.retryAction,
  }) : super(key: key);

  final Widget child;
  final LoadingStatusNotifier loadingStatusNotifier;
  final String emptyMessage;
  final bool isDisplayErrorAsAlert;
  final bool isErrorDialogDismissible;
  final Alignment indicatorPosition;
  final Color? overlayBackgroundColor;
  final double height;
  final Function? retryAction;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          _loaderOverlay(context),
        ],
      );

  Widget _loaderOverlay(context) {
    switch (loadingStatusNotifier.loadingStatus) {
      case LoadingStatus.loading:
        return Container(
          height: height,
          color: overlayBackgroundColor ?? Colors.grey.withOpacity(0.5),
          child: Align(
            alignment: indicatorPosition,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(backgroundColor),
            ),
          ),
        );

      case LoadingStatus.empty:
        return Center(child: NoResults(message: emptyMessage));
      case LoadingStatus.success:
        return Container();
      case LoadingStatus.failed:
        if (isDisplayErrorAsAlert) {
          return AlertDialog(
            backgroundColor: primaryColor.withOpacity(0.85),
            titlePadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            title: Text(
              "Something went wrong",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            content: Text(
              "Please try again later.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    if (isErrorDialogDismissible) {
                      // Navigator.of(context).pop();
                      // retryAction?.call();
                      if (retryAction != null) {
                        retryAction!(true);
                      }
                      loadingStatusNotifier.setLoadingStatus(
                          LoadingStatus.success, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: backgroundColor,
                  ),
                  child: const Text('OK')),
            ],
          );
        } else {
          return Center(
              child: NoResults(
                  message: "Something went wrong. Please try again."));
        }
    }
  }
}
