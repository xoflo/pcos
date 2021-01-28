import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/cms_grouped_list_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/view_models/cms_grouped_view_model.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class Questions extends StatefulWidget {
  final String cmsType;

  Questions({this.cmsType});

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  void initState() {
    super.initState();
    populateFAQs();
  }

  void populateFAQs() async {
    Provider.of<CMSGroupedListViewModel>(context, listen: false)
        .getCMSGrouped(widget.cmsType);
  }

  Widget getQuestionsList(Size screenSize, CMSGroupedListViewModel vm) {
    switch (vm.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        // TODO: create a widget for nothing found and test how it looks
        return Text("No items found!");
      case LoadingStatus.success:
        return ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                vm.cmsGroupedItems[index].isExpanded = !isExpanded;
              });
            },
            children: vm.cmsGroupedItems
                .map<ExpansionPanel>((CMSGroupedViewModel item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(
                      item.question,
                      style: TextStyle(color: primaryColorDark),
                    ),
                  );
                },
                body: ListTile(
                  title: Text(
                    item.answer,
                    style: TextStyle(color: textColor),
                  ),
                ),
                isExpanded: item.isExpanded,
                canTapOnHeader: true,
              );
            }).toList());
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CMSGroupedListViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: getQuestionsList(screenSize, vm),
    );
  }
}
