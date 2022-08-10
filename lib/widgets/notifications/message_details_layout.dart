import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';

class MessageDetailsLayout extends StatelessWidget {
  final Message message;
  final Function closeMessage;
  final Function(Message) deleteMessage;

  MessageDetailsLayout(
      {required this.message,
      required this.closeMessage,
      required this.deleteMessage});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: S.current.messageTitle,
            closeItem: closeMessage,
            unreadCount: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 10, right: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        message.title ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 20.0),
                      child: Text(
                            DateTimeUtils.shortDayDateMonthTime(message.dateCreatedUTC),
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
                            textAlign: TextAlign.left,
                          ),
                      ),
                    Text(message.message ?? "", textAlign: TextAlign.justify),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              deleteMessage(message);
            },
            child: Icon(
              Icons.delete,
              color: secondaryColor,
              size: 36,
            ),
          )
        ],
      ),
    );
  }
}
