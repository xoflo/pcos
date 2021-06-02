import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/providers/cms_text_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class PolicyLayout extends StatefulWidget {
  final String title;
  final String cmsAssetName;
  final String tryAgainText;

  PolicyLayout({this.title, this.cmsAssetName, this.tryAgainText});

  @override
  _PolicyLayoutState createState() => _PolicyLayoutState();
}

class _PolicyLayoutState extends State<PolicyLayout> {
  Widget getCMSText(final BuildContext context, final CMSTextProvider provider,
      final String assetName) {
    switch (provider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noItemsFound);
      case LoadingStatus.success:
        final cmsText = assetName == "Privacy"
            ? provider.privacyStatement
            : provider.termsStatement;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: HtmlWidget(
            cmsText,
          ),
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight,
                  child: Consumer<CMSTextProvider>(
                    builder: (context, cmsTextProvider, child) =>
                        SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getCMSText(
                            context, cmsTextProvider, widget.cmsAssetName),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
