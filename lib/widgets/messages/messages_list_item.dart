import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';

class MessagesListItem extends StatelessWidget {
  final Message message;
  final double width;
  final Function(BuildContext, Message) openMessageDetails;

  MessagesListItem(
      {@required this.message,
      @required this.width,
      @required this.openMessageDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 90.0,
      child: GestureDetector(
        onTap: () {
          openMessageDetails(context, message);
        },
        child: Card(
          child: Row(
            children: [
              SizedBox(
                width: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: message.isRead ? Colors.white : secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 6.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width - 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width - 90,
                            child: Text(
                              message.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Icon(
                            Icons.open_in_new,
                            color: secondaryColor,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width - 40,
                      child: Text(
                        message.message,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      DateTimeUtils.longDate(message.dateCreatedUTC.toLocal()),
                      style: TextStyle(fontSize: 12.0, color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
