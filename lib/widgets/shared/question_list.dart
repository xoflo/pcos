import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class QuestionList extends StatefulWidget {
  final Size screenSize;
  final List<Question> questions;
  final bool showIcon;
  final IconData iconData;
  final Function(FavouriteType, int) iconAction;

  QuestionList({
    @required this.screenSize,
    @required this.questions,
    this.showIcon = false,
    this.iconData,
    this.iconAction,
  });

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  ListTile getListTile(
    final bool showIcon,
    final String answerText,
    final int itemId,
  ) {
    if (showIcon) {
      return ListTile(
        title: Text(
          answerText,
          style: TextStyle(color: textColor),
        ),
        trailing: GestureDetector(
          onTap: () {
            widget.iconAction(FavouriteType.KnowledgeBase, itemId);
          },
          child: Icon(
            widget.iconData,
            color: secondaryColorLight,
            size: 24,
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(
          answerText,
          style: TextStyle(color: textColor),
        ),
      );
    }
  }

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
          body: getListTile(widget.showIcon, item.answer, item.id),
          isExpanded: item.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }
}
