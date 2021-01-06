import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/chat_message.dart';
import 'package:thepcosprotocol_app/widgets/chat/chat_text_input.dart';
import 'package:thepcosprotocol_app/widgets/chat/chat_speech_bubble.dart';

class CoachChat extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final List<ChatMessage> chatMessages = <ChatMessage>[
    ChatMessage(messageText: "", isUser: true),
    ChatMessage(messageText: "You are most welcome.", isUser: false),
    ChatMessage(messageText: "Thank you.", isUser: true),
    ChatMessage(
        messageText:
            "However. You might be able to do it if you instead use Rows and Columns layout. Additional logic it's required but the result should be possible.Since there is no code of how you implement the layout i will try my best to explain it.",
        isUser: false),
    ChatMessage(
        messageText:
            "I'm trying to write a simple layout using the Wrap widget. I'm wondering if there is any way to get elements to be placed in the first run rather than the last. For example, lets say I have a horizontal Wrap with 7 elements and I can fit four elements in each run. Instead of having the last three elements end up in a run (row) at the end, I would like the only the first three to end up in a run (row) at the beginning.",
        isUser: true),
    ChatMessage(
        messageText: "This is a slightly longer reply from the coach message",
        isUser: false),
    ChatMessage(messageText: "This is a short question?", isUser: true),
    ChatMessage(
        messageText: "And this is the first reply from the Coach.",
        isUser: false),
    ChatMessage(messageText: "This is the first question?", isUser: true),
  ];

  void sendMessage(BuildContext context, String messageText) {
    debugPrint("Send message=$messageText");
    Navigator.of(context).pop();
  }

  void displayAddComment(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        ),
        builder: (BuildContext context) {
          return ChatTextInput(
            formKey: _formKey,
            sendMessage: sendMessage,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final bubbleWidth = MediaQuery.of(context).size.width * 0.6;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox.expand(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(2.0),
              itemCount: chatMessages.length,
              itemBuilder: (BuildContext context, int index) {
                final String messageText = chatMessages[index].messageText;
                final bool isUser = chatMessages[index].isUser;
                return index == 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            displayAddComment(context);
                          },
                          child: Icon(Icons.add),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatSpeechBubble(
                          isUser: isUser,
                          messageText: messageText,
                          width: bubbleWidth,
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
