import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

/// UI widget that displays a [TextField] to add a [Reaction]/Comment to a
/// particular [activity].
class AddCommentBox extends StatefulWidget {
  const AddCommentBox({
    Key? key,
    required this.activity,
    required this.onAddComment,
  }) : super(key: key);

  final EnrichedActivity activity;
  final Function(Reaction?) onAddComment;

  @override
  State<AddCommentBox> createState() => _AddCommentBoxState();
}

class _AddCommentBoxState extends State<AddCommentBox> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final value = textController.text;
    textController.clear();

    if (value.isNotEmpty) {
      final reaction = await context.feedBloc.onAddReaction(
        kind: 'comment',
        activity: widget.activity,
        feedGroup: 'public',
        data: {'text': value},
      );

      // Lose the focus on the text field.
      FocusScope.of(context).unfocus();

      if(reaction.activityId != null && reaction.createdAt != null) {
        widget.onAddComment(reaction);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Divider(
        color: Colors.grey,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 32),
        child: TextField(
          controller: textController,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          onSubmitted: ((value) {
            _addComment();
          }),
          decoration: InputDecoration(
            hintText: 'Add a comment',
            suffix: IconButton(
              onPressed: _addComment,
              icon: const Icon(
                Icons.send,
                color: backgroundColor,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: backgroundColor),
            ),
          ),
        ),
      )
    ]);
  }
}
