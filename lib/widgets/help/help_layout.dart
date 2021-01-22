import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/help/getting_started.dart';
import 'package:thepcosprotocol_app/widgets/help/frequently_asked_questions.dart';
import 'package:thepcosprotocol_app/controllers/cms_controller.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';

class HelpLayout extends StatefulWidget {
  final String tryAgainText;
  final Function closeMenuItem;

  HelpLayout({this.tryAgainText, this.closeMenuItem});

  @override
  _HelpLayoutState createState() => _HelpLayoutState();
}

class _HelpLayoutState extends State<HelpLayout> {
  double _getTabBarHeight(BuildContext context, bool isHorizontal) {
    return DeviceUtils.getRemainingHeight(
        MediaQuery.of(context).size.height, true, isHorizontal);
  }

  String _gettingStartedContent = "";

  @override
  void initState() {
    super.initState();
    _getHelpContent();
  }

  void _getHelpContent() async {
    final String cmsResponse = await CmsController()
        .getCmsAsset("GettingStarted", widget.tryAgainText);

    setState(() {
      _gettingStartedContent = cmsResponse;
    });

    final String cmsAsset = await WebServices().getFrequentlyAskedQuestions();
    debugPrint("*********called FAQs $cmsAsset");
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Scaffold(
      backgroundColor: primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
            bottom: 6.0,
            left: 6.0,
            right: 6.0,
          ),
          child: Container(
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
                  title: S.of(context).helpTitle,
                  isFavourite: false,
                  closeItem: widget.closeMenuItem,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: TabBar(
                            isScrollable: true,
                            tabs: [
                              Tab(text: S.of(context).gettingStarted),
                              Tab(text: S.of(context).frequentlyAskedQuestions),
                              Tab(text: S.of(context).courseQuestions),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            //Add this to give height
                            height: _getTabBarHeight(context, isHorizontal),
                            child: TabBarView(
                              children: [
                                GettingStarted(
                                  gettingStartedContent: _gettingStartedContent,
                                ),
                                FrequentlyAskedQuestions(),
                                Text("Course questions"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
