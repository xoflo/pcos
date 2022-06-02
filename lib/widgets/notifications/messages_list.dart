import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/providers/messages_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key? key,
    required this.showMessageReadOption,
    this.messagesProvider,
    this.openMessage,
    this.onPressMarkAsRead,
  }) : super(key: key);

  final MessagesProvider? messagesProvider;
  final Function(BuildContext, MessagesProvider?, Message)? openMessage;
  final Function()? onPressMarkAsRead;
  final bool showMessageReadOption;

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
    if (!widget.showMessageReadOption) {
      _selectedMessages.clear();
    }
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.messagesProvider?.items.map(
                    (Message message) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 25, horizontal: 15),
                            child: Row(
                              children: [
                                if (widget.showMessageReadOption)
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (!_selectedMessages
                                            .contains(message)) {
                                          _selectedMessages.add(message);
                                        } else {
                                          _selectedMessages.remove(message);
                                        }
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
                                GestureDetector(
                                  child: Text(message.title ?? ""),
                                  onTap: () => _openMessage(context, message),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: textColor,
                          )
                        ],
                      );
                    },
                  ).toList() ??
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
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      child: Text("Mark as read")),
                  onPressed: _selectedMessages.length == 0
                      ? null
                      : () {
                          _selectedMessages.forEach((message) =>
                              widget.messagesProvider?.updateNotificationAsRead(
                                  message.notificationId));
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
      ),
    );
  }
}
