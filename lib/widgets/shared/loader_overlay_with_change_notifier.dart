import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

/// A Widget that makes another widget overlayed with a progress indicator on top of it.
/// Purpose of which is to move out the logic behind the appearance/disappearance of
/// the progress indicator in the child widget into this LoadOverlay widget
/// Status of said child widget where the loader overlay will be applied must be provided
/// by a change notifier consumed by child widget. This change notifier must implement
/// LoadingStatusNotifier.
/// The change notifier must have its own status attribute of type LoadingStatus and must
/// call setLoadingStatus(fetchAndSaveDataStatus, false); each time its status changes.
class LoaderOverlay extends StatefulWidget {
  LoaderOverlay({
    Key? key,
    required this.child,
    required this.loadingStatusNotifier,
    required this.indicatorPosition,
    this.overlayBackgroundColor,
    required this.height,
    this.loadingMessage = "",
    this.emptyMessage = "",
    this.isDisplayErrorAsAlert = true,
    this.isErrorDialogDismissible = true,
    this.retryAction,
    this.positionalParams,
    this.namedParams,
  }) : super(key: key);

  final Widget child;
  final LoadingStatusNotifier loadingStatusNotifier;
  final String loadingMessage;
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
  State<LoaderOverlay> createState() => _LoaderOverlayState();
}

class _LoaderOverlayState extends State<LoaderOverlay> {
  Timer? _sustainCheckTimer;
  bool _isSustainedLoading = false;

  @override
  void dispose() {
    _sustainCheckTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _checkLoadingStatus();

    return Stack(
        children: [
          widget.child,
          _loaderOverlay(context),
        ],
      );
  }

  void _checkLoadingStatus() {
    switch (widget.loadingStatusNotifier.loadingStatus) {
      case LoadingStatus.loading:
        // Only show loading message if it's been loading for longer than a second
        _sustainCheckTimer = Timer(Duration(seconds: 1), () {
          if (!_isSustainedLoading) {
            setState(() {
              _isSustainedLoading = true;
            });
          }
        });
        break;
      default:
        {
          // Cancel any pending sustained timer if `LoadingStatus` is not `loading`
          _sustainCheckTimer?.cancel();

          setState(() {
            _isSustainedLoading = false;
          });
        }
        break;
    }
  }

  Widget _loaderOverlay(BuildContext context) {
    switch (widget.loadingStatusNotifier.loadingStatus) {
      case LoadingStatus.loading:
        return Container(
          height: widget.height,
          color: widget.overlayBackgroundColor ?? Colors.grey.withOpacity(0.5),
          child: Align(
            alignment: widget.indicatorPosition,
            child: SizedBox(
              width: 200,
              height: 110,
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(backgroundColor),
                  ),
                  if (widget.loadingMessage.length > 0 && _isSustainedLoading) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        widget.loadingMessage,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: backgroundColor),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );

      case LoadingStatus.empty:
        return Center(child: NoResults(message: widget.emptyMessage));
      case LoadingStatus.success:
        return Container();
      case LoadingStatus.failed:
        if (widget.isDisplayErrorAsAlert) {
          Widget retryButton = FilledButton(
            margin: EdgeInsets.zero,
            text: "Retry",
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
            onPressed: () {
              if (widget.isErrorDialogDismissible) {
                if (widget.retryAction != null) {
                  Function.apply(widget.retryAction!, widget.positionalParams, widget.namedParams);
                }
                widget.loadingStatusNotifier.setLoadingStatus(
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
