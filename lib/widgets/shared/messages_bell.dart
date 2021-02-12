import 'package:flutter/material.dart';

class MessagesBell extends StatelessWidget {
  final int messagesCount;

  MessagesBell({@required this.messagesCount});

  @override
  Widget build(BuildContext context) {
    debugPrint("***************COUNT = $messagesCount");
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 30,
          ),
        ),
        messagesCount == null || messagesCount == 0
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      messagesCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
