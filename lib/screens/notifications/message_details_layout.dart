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

  MessageDetailsLayout({
    required this.message,
    required this.closeMessage,
    required this.deleteMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            title: S.current.messageTitle,
            closeItem: closeMessage,
            onDelete: () => deleteMessage(message),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      message.title ?? "",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    SizedBox(height: 10),
                    Text(
                      DateTimeUtils.shortDayDateMonthTime(
                          message.dateCreatedUTC),
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            color: textColor.withOpacity(0.5),
                          ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      message.message ?? "",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: textColor.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
