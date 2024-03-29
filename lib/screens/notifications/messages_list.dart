import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key? key,
    required this.showMessageReadOption,
    required this.isAllSelected,
    this.messagesProvider,
    this.openMessage,
    this.onSelectItem,
    this.onPressMarkAsRead,
  }) : super(key: key);

  final MessagesProvider? messagesProvider;
  final Function(BuildContext, MessagesProvider?, Message)? openMessage;
  final Function()? onPressMarkAsRead;
  final Function(bool)? onSelectItem;
  final bool showMessageReadOption;
  final bool isAllSelected;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  List<Message> _selectedMessages = [];
  void _openMessage(final BuildContext context, final Message message) {
    widget.openMessage?.call(context, widget.messagesProvider, message);
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.messagesProvider?.items ?? [];

    // If 'Select all' is pressed, then we add all the message
    // items, whilst removing duplicate items. Otherwise, we
    // clear the items when all the messages are selecte
    if (widget.isAllSelected) {
      _selectedMessages.addAll(messages);
      _selectedMessages = _selectedMessages.toSet().toList();
    } else if (messages.length == _selectedMessages.length) {
      _selectedMessages.clear();
    }
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.messagesProvider?.items
                    .map(
                      (message) => GestureDetector(
                        onTap: () => _openMessage(context, message),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 15),
                              child: Row(
                                children: [
                                  if (widget.showMessageReadOption)
                                    IconButton(
                                      padding: EdgeInsets.only(top: 2.0),
                                      alignment: Alignment.topCenter,
                                      onPressed: () {
                                        setState(() {
                                          if (!_selectedMessages
                                              .contains(message)) {
                                            _selectedMessages.add(message);
                                          } else {
                                            _selectedMessages.remove(message);
                                          }
                                          widget.onSelectItem?.call(
                                              _selectedMessages.length ==
                                                  messages.length);
                                        });
                                      },
                                      icon: Icon(
                                        _selectedMessages.contains(message)
                                            ? Icons.check_box_outlined
                                            : Icons
                                                .check_box_outline_blank_outlined,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.title ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              color: textColor.withOpacity(0.8),
                                              fontWeight: message.isRead == true
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                            ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          DateTimeUtils.shortDayDateMonthTime(
                                              message.dateCreatedUTC),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              ?.copyWith(
                                                color:
                                                    textColor.withOpacity(0.8),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: textColor.withOpacity(0.2),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
        if (widget.showMessageReadOption)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    child: Text("Mark as read")),
                onPressed: _selectedMessages.length == 0
                    ? null
                    : () {
                        _selectedMessages.forEach((message) => widget
                            .messagesProvider
                            ?.updateNotificationAsRead(message.notificationId));
                        widget.onPressMarkAsRead?.call();
                      },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return Colors.white;
                  }),
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return backgroundColor.withOpacity(0.5);
                    }
                    return backgroundColor;
                  }),
                  textStyle: MaterialStateProperty.resolveWith(
                    (states) => const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: MaterialStateProperty.resolveWith<StadiumBorder>(
                    (states) => StadiumBorder(),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
