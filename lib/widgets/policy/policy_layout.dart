import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/providers/cms_text_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
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
          child: Html(
            data: cmsText,
          ),
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

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
          Container(
            height: DeviceUtils.getRemainingHeight(
                MediaQuery.of(context).size.height,
                false,
                isHorizontal,
                false,
                false),
            child: Consumer<CMSTextProvider>(
              builder: (context, cmsTextProvider, child) =>
                  SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      getCMSText(context, cmsTextProvider, widget.cmsAssetName),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
