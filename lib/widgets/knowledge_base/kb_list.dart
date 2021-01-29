import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/view_models/cms_grouped_view_model.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class KnowledgeBaseList extends StatefulWidget {
  final Size screenSize;
  final List<CMSGroupedViewModel> knowledgeBases;

  KnowledgeBaseList({this.screenSize, this.knowledgeBases});

  @override
  _KnowledgeBaseListState createState() => _KnowledgeBaseListState();
}

class _KnowledgeBaseListState extends State<KnowledgeBaseList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.knowledgeBases[index].isExpanded = !isExpanded;
        });
      },
      children:
          widget.knowledgeBases.map<ExpansionPanel>((CMSGroupedViewModel item) {
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
      }).toList(),
    );
  }
}
