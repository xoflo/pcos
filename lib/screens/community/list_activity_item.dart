import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'comments_page.dart';

/// UI widget to display an activity/post.
///
/// Shows the number of likes and comments.
///
/// Enables the current [User] to like the activity, and view comments.
class ListActivityItem extends StatelessWidget {
  const ListActivityItem({
    Key? key,
    required this.user,
    required this.activity,
    required this.feedGroup,
  }) : super(key: key);

  final EnrichedActivity activity;
  final String feedGroup;
  final String user;

  @override
  Widget build(BuildContext context) {
    final attachments = (activity.extraData)?.toAttachments();
    final reactionCounts = activity.reactionCounts;
    final ownReactions = activity.ownReactions;
    final isLikedByUser = (ownReactions?['like']?.length ?? 0) > 0;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(''), //actor.profileImage
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(user), //actor.fullName
            const SizedBox(width: 8),
            Text(
              '@' + user,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${activity.object}'),
          ),
          if (attachments != null && attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(attachments[0].url),
            ),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
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
                    icon: isLikedByUser
                        ? const Icon(Icons.favorite_rounded)
                        : const Icon(Icons.favorite_outline),
                  ),
                  if (reactionCounts?['like'] != null)
                    Text(
                      '${reactionCounts?['like']}',
                      style: Theme.of(context).textTheme.caption,
                    )
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    onPressed: () => _navigateToCommentPage(context),
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                  if (reactionCounts?['comment'] != null)
                    Text(
                      '${reactionCounts?['comment']}',
                      style: Theme.of(context).textTheme.caption,
                    )
                ],
              )
            ],
          )
        ],
      ),
      onTap: () {
        _navigateToCommentPage(context);
      },
    );
  }

  void _navigateToCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CommentsPage(
          activity: activity,
        ),
      ),
    );
  }
}
