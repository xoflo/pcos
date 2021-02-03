import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class QuestionList extends StatefulWidget {
  final Size screenSize;
  final List<Question> questions;

  QuestionList({this.screenSize, this.questions});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.questions[index].isExpanded = !isExpanded;
        });
      },
      children: widget.questions.map<ExpansionPanel>((Question item) {
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
