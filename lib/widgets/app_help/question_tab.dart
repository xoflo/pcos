import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/providers/app_help_provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class QuestionTab extends StatelessWidget {
  final bool isHorizontal;
  final AppHelpProvider faqProvider;

  QuestionTab({
    @required this.isHorizontal,
    this.faqProvider,
  });

  Widget getQuestionList(final BuildContext context, final provider) {
    switch (provider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.of(context).noItemsFound);
      case LoadingStatus.success:
        return QuestionList(
          questions: provider.items,
          wikis: [],
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: getQuestionList(context, faqProvider),
    );
  }
}
