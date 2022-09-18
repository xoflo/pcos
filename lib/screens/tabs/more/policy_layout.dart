import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thepcosprotocol_app/providers/cms_text_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class PolicyLayout extends StatefulWidget {
  final String? title;
  final String? cmsAssetName;
  final String? tryAgainText;

  PolicyLayout({this.title, this.cmsAssetName, this.tryAgainText});

  @override
  _PolicyLayoutState createState() => _PolicyLayoutState();
}

class _PolicyLayoutState extends State<PolicyLayout> {
  @override
  Widget build(BuildContext context) {
    final cmsTextProvider = Provider.of<CMSTextProvider>(context);
    final cmsText = widget.cmsAssetName == "Privacy"
        ? cmsTextProvider.privacyStatement
        : cmsTextProvider.termsStatement;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: widget.title,
            closeItem: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: LoaderOverlay(
                height: double.maxFinite,
                loadingStatusNotifier: cmsTextProvider,
                emptyMessage: S.current.noItemsFound,
                indicatorPosition: Alignment.center,
                overlayBackgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: HtmlWidget(
                    cmsText,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                    onLoadingBuilder: (_, __, ___) => PcosLoadingSpinner(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
