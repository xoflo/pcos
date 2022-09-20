import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

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
    this.positionalParams,
    this.namedParams,
  }) : super(key: key);

  final Widget child;
  final LoadingStatusNotifier loadingStatusNotifier;
  final String emptyMessage;
  final bool isDisplayErrorAsAlert;
  final bool isErrorDialogDismissible;
  final Alignment indicatorPosition;
  final Color? overlayBackgroundColor;
  final double height;
  final List<dynamic>? positionalParams;
  final Map<Symbol, dynamic>? namedParams;
  final Function? retryAction;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          _loaderOverlay(context),
        ],
      );

  Widget _loaderOverlay(BuildContext context) {
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
          Widget retryButton = FilledButton(
            margin: EdgeInsets.zero,
            text: "Retry",
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
            onPressed: () {
              if (isErrorDialogDismissible) {
                if (retryAction != null) {
                  Function.apply(retryAction!, positionalParams, namedParams);
                }
                loadingStatusNotifier.setLoadingStatus(
                    LoadingStatus.success, true);
              }
            },
          );
          List<Widget> actions = [];
          actions.add(retryButton);

          return createAlertDialogWidget(
              S.current.warningText, S.current.internetConnectionText, actions);
        } else {
          return Center(
              child: NoResults(message: S.current.somethingWentWrongMessage));
        }
    }
  }
}
