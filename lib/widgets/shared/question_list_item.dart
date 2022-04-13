import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class QuestionListItem extends StatefulWidget {
  final bool? showIcon;
  final String? answerText;
  final dynamic item;
  final bool? isFavorite;
  final IconData? iconData;
  final IconData? iconDataOn;
  final Function(FavouriteType, dynamic, bool)? iconAction;

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
    isFavoriteQuestion = widget.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showIcon == true) {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: HtmlWidget(widget.answerText ?? ""),
        ),
        trailing: GestureDetector(
          onTap: () {
            final bool add = !isFavoriteQuestion;
            setState(() {
              isFavoriteQuestion = add;
            });
            widget.iconAction?.call(FavouriteType.Wiki, widget.item, add);
          },
          child: Icon(
            isFavoriteQuestion ? widget.iconDataOn : widget.iconData,
            color: secondaryColor,
            size: 24,
          ),
        ),
      );
    } else {
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: HtmlWidget(widget.answerText ?? ""),
        ),
      );
    }
  }
}
