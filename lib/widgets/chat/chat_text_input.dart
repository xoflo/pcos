import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ChatTextInput extends StatelessWidget {
  final formKey;
  final Function(BuildContext, String) sendMessage;
  final TextEditingController chatController = TextEditingController();

  ChatTextInput({this.formKey, this.sendMessage});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                12.0, 12.0, 12.0, 0.0), // content padding
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    controller: chatController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: S.of(context).enterMessageText,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).validateMessageText;
                      }
                      return null;
                    },
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (formKey.currentState.validate()) {
                        final String messageText = chatController.text.trim();
                        chatController.clear();
                        sendMessage(context, messageText);
                      }
                    },
                    child: Text(
                      S.of(context).sendButtonText,
                      style: TextStyle(
                        color: primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            )), // From with TextField inside
      ),
    );
  }
}
