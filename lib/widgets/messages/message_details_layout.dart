import 'package:flutter/cupertino.dart';
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
      {@required this.message,
      @required this.closeMessage,
      @required this.deleteMessage});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            title: S.of(context).messageTitle,
            closeItem: closeMessage,
            showMessagesIcon: false,
            unreadCount: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 10, right: 10, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        message.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Text(message.message, textAlign: TextAlign.justify),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            DateTimeUtils.longDate(
                                message.dateCreatedUTC.toLocal()),
                            style: TextStyle(fontSize: 12.0, color: textColor),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
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
