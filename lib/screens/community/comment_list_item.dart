import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'package:timeago/timeago.dart' as timeago;

class CommentListItem extends StatefulWidget {
  const CommentListItem({Key? key, required this.reaction}) : super(key: key);

  final Reaction reaction;

  @override
  _CommentListItemState createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem>
    with AutomaticKeepAliveClientMixin {
  Map<String, int>? reactionCounts;
  Map<String, List<Reaction>>? ownReactions;
  Reaction? ownLikeReaction;
  bool isLikedByUser = false;

  @override
  void initState() {
    super.initState();
    ownReactions = widget.reaction.ownChildren;
    reactionCounts = widget.reaction.childrenCounts;
    isLikedByUser = (widget.reaction.ownChildren?['like']?.length ?? 0) > 0;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = widget.reaction.user?.data?['user_name'] as String;

    Future<void> _addOrRemoveLike(Reaction reaction) async {
      if (isLikedByUser) {
        List<Reaction>? likedReactions = reaction.ownChildren?['like'];

        if (likedReactions == null && ownLikeReaction != null) {
          likedReactions = [ownLikeReaction!];
        }

        if (likedReactions != null && likedReactions.isNotEmpty) {
          FeedProvider.of(context).bloc.onRemoveChildReaction(
                kind: 'like',
                childReaction: likedReactions[0],
                lookupValue: reaction.id!,
                parentReaction: reaction,
              );
        }
      } else {
        FeedProvider.of(context)
            .bloc
            .onAddChildReaction(
              kind: 'like',
              reaction: reaction,
              lookupValue: reaction.id!,
            )
            .then((value) => ownLikeReaction = value);
      }

      setState(() {
        isLikedByUser = !isLikedByUser;
        int curLikes = reactionCounts?['like']?.toInt() ?? 0;
        if (!isLikedByUser) {
          reactionCounts?['like'] = (curLikes - 1);
        } else {
          reactionCounts?['like'] = (curLikes + 1);
        }
      });
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
                        widget.reaction.updatedAt!,
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
                          '${widget.reaction.data?['text']}',
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
          Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    iconSize: 20,
                    onPressed: () {
                      _addOrRemoveLike(widget.reaction);
                    },
                    color: backgroundColor,
                    icon: isLikedByUser
                        ? Icon(Icons.favorite, key: widget.key)
                        : Icon(Icons.favorite_border, key: widget.key),
                  ),
                  Text(_displayNumberOfLikes(reactionCounts?['like'] ?? 0,),
                      key: widget.key,
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
            ],
          ),
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
