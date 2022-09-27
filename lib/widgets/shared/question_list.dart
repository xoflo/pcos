import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list_item.dart';

class QuestionList extends StatefulWidget {
  final List<Question>? questions;
  final List<LessonWiki>? wikis;
  final bool showIcon;
  final IconData? iconData;
  final IconData? iconDataOn;
  final Function(FavouriteType, dynamic, bool)? iconAction;

  QuestionList({
    this.questions,
    this.wikis,
    this.showIcon = false,
    this.iconData,
    this.iconDataOn,
    this.iconAction,
  });

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    FavouritesProvider favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);

    return ExpansionPanelList(
      dividerColor: dividerColor,
      expansionCallback: (int index, bool isExpanded) {
        //remove the focus from the searchbox if necessary, to hide the keyboard
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        setState(() {
          if ((widget.questions?.length ?? 0) > 0) {
            widget.questions?[index].isExpanded = !isExpanded;
          } else {
            widget.wikis?[index].isExpanded = !isExpanded;
          }
        });
      },
      children: (widget.questions?.length ?? 0) > 0
          ? widget.questions!.map<ExpansionPanel>((Question item) {
              return ExpansionPanel(
                backgroundColor: primaryColor,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(
                          top: 25,
                          bottom: 25,
                          left: 15,
                          right: 30,
                        ),
                        title: Text(
                          item.question ?? "",
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                body: QuestionListItem(
                  showIcon: false,
                  answerText: item.answer,
                  item: item,
                  isFavorite: false,
                  iconData: widget.iconData,
                  iconDataOn: widget.iconDataOn,
                  iconAction: widget.iconAction,
                ),
                isExpanded: item.isExpanded,
                canTapOnHeader: true,
              );
            }).toList()
          : widget.wikis!.map<ExpansionPanel>((LessonWiki item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(
                      item.question ?? "",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                body: QuestionListItem(
                  showIcon: widget.showIcon,
                  answerText: item.answer,
                  item: item,
                  isFavorite: favouritesProvider.isFavourite(
                      FavouriteType.Wiki, item.questionId),
                  iconData: widget.iconData,
                  iconDataOn: widget.iconDataOn,
                  iconAction: widget.iconAction,
                ),
                isExpanded: item.isExpanded,
                canTapOnHeader: true,
              );
            }).toList(),
    );
  }
}
