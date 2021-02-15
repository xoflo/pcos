import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/help/getting_started.dart';
import 'package:thepcosprotocol_app/controllers/cms_controller.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/providers/course_question_provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class HelpLayout extends StatefulWidget {
  final String tryAgainText;
  final Function closeMenuItem;
  final FAQProvider faqProvider;
  final CourseQuestionProvider courseQuestionProvider;

  HelpLayout({
    this.tryAgainText,
    this.closeMenuItem,
    this.faqProvider,
    this.courseQuestionProvider,
  });

  @override
  _HelpLayoutState createState() => _HelpLayoutState();
}

class _HelpLayoutState extends State<HelpLayout> {
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
  }

  Widget getQuestionList(
      final BuildContext context, final Size screenSize, final provider) {
    switch (provider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noItemsFound);
      case LoadingStatus.success:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child:
              QuestionList(screenSize: screenSize, questions: provider.items),
        );
    }
    return Container();
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
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: S.of(context).helpTitle,
                  closeItem: widget.closeMenuItem,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
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
                            height: DeviceUtils.getRemainingHeight(
                                MediaQuery.of(context).size.height,
                                true,
                                isHorizontal,
                                false,
                                false),
                            child: TabBarView(
                              children: [
                                GettingStarted(
                                  gettingStartedContent: _gettingStartedContent,
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: getQuestionList(context, screenSize,
                                        widget.faqProvider),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: getQuestionList(context, screenSize,
                                        widget.courseQuestionProvider),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}