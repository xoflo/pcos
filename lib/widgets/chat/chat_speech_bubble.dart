import 'package:flutter/material.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ChatSpeechBubble extends StatelessWidget {
  final bool isUser;
  final String messageText;
  final double width;

  ChatSpeechBubble({this.isUser, this.messageText, this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: isUser ? TextDirection.ltr : TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SpeechBubble(
          width: width,
          color: isUser ? primaryColor : primaryColorDark,
          nipLocation: isUser ? NipLocation.RIGHT : NipLocation.LEFT,
          child: Text(
            messageText,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding:
              isUser ? EdgeInsets.only(left: 8.0) : EdgeInsets.only(right: 8.0),
          child: Icon(
            isUser ? Icons.sentiment_neutral : Icons.face,
            color: primaryColor,
            size: 28.0,
          ),
        ),
      ],
    );
  }
}
