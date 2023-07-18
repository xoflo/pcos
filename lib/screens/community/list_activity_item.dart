import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'comments_page.dart';

/// UI widget to display an activity/post.
///
/// Shows the number of likes and comments.
///
/// Enables the current [User] to like the activity, and view comments.
class ListActivityItem extends StatelessWidget {
  const ListActivityItem(
      {Key? key,
      required this.user,
      required this.activity,
      required this.feedGroup,
      required this.isLandscapeImage})
      : super(key: key);

  final EnrichedActivity activity;
  final String feedGroup;
  final String user;
  final bool isLandscapeImage;

  @override
  Widget build(BuildContext context) {
    final attachments = (activity.extraData)?.toAttachments();
    final reactionCounts = activity.reactionCounts;
    final ownReactions = activity.ownReactions;
    final isLikedByUser = (ownReactions?['like']?.length ?? 0) > 0;
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(''),
              ),
              SizedBox(
                width: 10,
              ),
              Text(user),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              if (attachments != null && attachments.isNotEmpty)
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: isLandscapeImage ? 300 : 500,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(attachments[0].url),
                      ),
                    ))
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    iconSize: 30,
                    onPressed: () {
                      if (isLikedByUser) {
                        context.feedBloc.onRemoveReaction(
                          kind: 'like',
                          activity: activity,
                          reaction: ownReactions!['like']![0],
                          feedGroup: feedGroup,
                        );
                      } else {
                        context.feedBloc.onAddReaction(
                            kind: 'like',
                            activity: activity,
                            feedGroup: feedGroup);
                      }
                    },
                    color: isLikedByUser ? backgroundColor : Colors.grey,
                    icon: isLikedByUser
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 25,
                    onPressed: () => _navigateToCommentPage(context),
                    icon: const Icon(
                      Icons.message_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  if (reactionCounts?['comment'] != null)
                    Text(
                      '${reactionCounts?['comment']}',
                      style: Theme.of(context).textTheme.caption,
                    )
                ],
              )
            ],
          ),
          if (reactionCounts?['like'] != null)
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 0, right: 20, bottom: 0),
                child: Text(
                  _displayNumberOfLikes(reactionCounts?['like']),
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.left,
                ),
              )
            ]),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 10, right: 20, bottom: 10),
                child: Text(
                  '${activity.object}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _navigateToCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => CommentsPage(
                activity: activity,
              ),
          fullscreenDialog: true),
    );
  }

  String _displayNumberOfLikes(int? numberOfLikes) {
    if (numberOfLikes != null) {
      String likesText = numberOfLikes > 1 ? "Likes" : "Like";
      return '$numberOfLikes' + " " + likesText;
    } else {
      return "";
    }
  }
}
