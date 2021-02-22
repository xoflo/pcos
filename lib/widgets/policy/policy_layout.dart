import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/cms_controller.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class PolicyLayout extends StatefulWidget {
  final String title;
  final String cmsAssetName;
  final String tryAgainText;

  PolicyLayout({this.title, this.cmsAssetName, this.tryAgainText});

  @override
  _PolicyLayoutState createState() => _PolicyLayoutState();
}

class _PolicyLayoutState extends State<PolicyLayout> {
  String _cmsBody = "";

  @override
  void initState() {
    super.initState();
    _getPrivacyStatement();
  }

  void _getPrivacyStatement() async {
    final String cmsResponse = await CmsController()
        .getCmsAsset(widget.cmsAssetName, widget.tryAgainText);

    setState(() {
      _cmsBody = cmsResponse;
    });
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _cmsBody.length == 0
                    ? PcosLoadingSpinner()
                    : Html(
                        data: _cmsBody,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
