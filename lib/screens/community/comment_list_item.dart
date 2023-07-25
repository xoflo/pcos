import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'package:timeago/timeago.dart' as timeago;

class CommentListItem extends StatelessWidget {
  const CommentListItem({Key? key, required this.reaction, this.isOwnComment}) : super(key: key);

  final Reaction reaction;
  final bool? isOwnComment;

  @override
  Widget build(BuildContext context) {
    final user = reaction.user?.data?['user_name'] as String;
    final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;
    final numberOfLikes = reaction.ownChildren?['like']?.length ?? 0;

    Future<void> _addOrRemoveLike(Reaction reaction) async {
      final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;
      if (isLikedByUser) {
        FeedProvider.of(context).bloc.onRemoveChildReaction(
              kind: 'like',
              childReaction: reaction.ownChildren!['like']![0],
              lookupValue: reaction.id!,
              parentReaction: reaction,
            );
      } else {
        FeedProvider.of(context).bloc.onAddChildReaction(
              kind: 'like',
              reaction: reaction,
              lookupValue: reaction.id!,
            );
      }
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 0, right: 20),
                child: Row(
                  children: [
                    Text(
                      "@" + user, //activity.actor?.data?['user_name']
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      '  ${timeago.format(
                        reaction.updatedAt!,
                        allowFromNow: true,
                      )}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w200, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 10,
                        right: 20,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 64,
                        child: Text(
                          '${reaction.data?['text']}',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ))
                ],
              )
            ],
          ),
          if (isOwnComment != true) ...[
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    _addOrRemoveLike(reaction);
                  },
                  color: backgroundColor,
                  icon: isLikedByUser
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                ),
                Text(_displayNumberOfLikes(numberOfLikes),
                    style: Theme.of(context).textTheme.caption)
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _displayNumberOfLikes(int count) {
    if (count != 0) {
      String displayText = count > 1 ? "Likes" : "Like";
      return '$count' + " " + displayText;
    } else {
      return "";
    }
  }
}
