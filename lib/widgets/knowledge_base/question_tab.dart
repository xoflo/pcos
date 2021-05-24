import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/providers/faq_provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class QuestionTab extends StatelessWidget {
  final Size screenSize;
  final bool isHorizontal;
  final bool isFAQ;
  final FAQProvider faqProvider;

  QuestionTab({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.isFAQ,
    this.faqProvider,
  });

  Widget getQuestionList(
      final BuildContext context, final Size screenSize, final provider) {
    switch (provider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noItemsFound);
      case LoadingStatus.success:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child:
              QuestionList(screenSize: screenSize, questions: provider.items),
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: getQuestionList(context, screenSize, faqProvider),
      ),
    );
  }
}
