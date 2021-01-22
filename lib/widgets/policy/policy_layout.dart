import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/controllers/cms_controller.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class PolicyLayout extends StatefulWidget {
  final String title;
  final String cmsAssetName;
  final String tryAgainText;
  final Function closeMenuItem;

  PolicyLayout(
      {this.title, this.cmsAssetName, this.tryAgainText, this.closeMenuItem});

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
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            itemId: 0,
            favouriteType: FavouriteType.None,
            title: widget.title,
            isFavourite: false,
            closeItem: widget.closeMenuItem,
          ),
          Container(
            height: DeviceUtils.getRemainingHeight(
                MediaQuery.of(context).size.height, false, isHorizontal),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _cmsBody.length == 0
                    ? CircularProgressIndicator()
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
