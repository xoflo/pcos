import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class QuestionListItem extends StatefulWidget {
  final bool showIcon;
  final String answerText;
  final Question item;
  final bool isFavorite;
  final IconData iconData;
  final IconData iconDataOn;
  final Function(FavouriteType, Question, bool) iconAction;

  QuestionListItem({
    this.showIcon,
    this.answerText,
    this.item,
    this.isFavorite,
    this.iconData,
    this.iconDataOn,
    this.iconAction,
  });
  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem> {
  bool isFavoriteQuestion = false;

  @override
  void initState() {
    super.initState();
    isFavoriteQuestion = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showIcon) {
      return ListTile(
        title: Text(
          widget.answerText,
          style: TextStyle(color: textColor),
        ),
        trailing: GestureDetector(
          onTap: () {
            final bool add = !isFavoriteQuestion;
            setState(() {
              isFavoriteQuestion = add;
            });
            widget.iconAction(FavouriteType.KnowledgeBase, widget.item, add);
          },
          child: Icon(
            isFavoriteQuestion ? widget.iconDataOn : widget.iconData,
            color: secondaryColorLight,
            size: 24,
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(
          widget.answerText,
          style: TextStyle(color: textColor),
        ),
      );
    }
  }
}
