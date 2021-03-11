import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/knowledge_base_provider.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/providers/course_question_provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/kb_tab.dart';
import 'package:thepcosprotocol_app/widgets/knowledge_base/question_tab.dart';

class KnowledgeBaseLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: screenSize.width,
            decoration: BoxDecoration(color: Colors.white),
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: S.of(context).knowledgeBaseTitle,
                    icon: Icon(
                      Icons.psychology,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.of(context).frequentlyAskedQuestions,
                    icon: Icon(
                      Icons.help,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Tab(
                    text: S.of(context).courseQuestions,
                    icon: Icon(
                      Icons.school,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 4.0,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 1.0,
            child: Container(
              decoration: BoxDecoration(color: primaryColor),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
              ),
              child: Container(
                //Add this to give height
                height: DeviceUtils.getRemainingHeight(
                    MediaQuery.of(context).size.height,
                    true,
                    isHorizontal,
                    true,
                    true),
                child: TabBarView(
                  children: [
                    Consumer<KnowledgeBaseProvider>(
                      builder: (context, model, child) => KnowledgeBaseTab(
                        screenSize: screenSize,
                        isHorizontal: isHorizontal,
                        knowledgeBaseProvider: model,
                      ),
                    ),
                    Consumer<FAQProvider>(
                      builder: (context, faqModel, child) => QuestionTab(
                        screenSize: screenSize,
                        isHorizontal: isHorizontal,
                        isFAQ: true,
                        faqProvider: faqModel,
                      ),
                    ),
                    Consumer<CourseQuestionProvider>(
                      builder: (context, courseQuestionModel, child) =>
                          QuestionTab(
                        screenSize: screenSize,
                        isHorizontal: isHorizontal,
                        isFAQ: false,
                        courseQuestionProvider: courseQuestionModel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
