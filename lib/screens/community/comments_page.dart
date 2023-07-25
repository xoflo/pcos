import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'add_comment_box.dart';
import 'comment_list_item.dart';

/// A page that displays all [Reaction]s/comments for a specific
/// [Activity]/Post.
///
/// Enabling the current [User] to add comments and like other reactions.
class CommentsPage extends StatefulWidget {
  const CommentsPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  bool _isPaginating = false;

  List<Reaction> _ownComments = [];

  Future<void> _loadMore() async {
    // Ensure we're not already loading more reactions.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreReactions(widget.activity.id!, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  // Optimistically add the comment to the list of comments.
  void _addComment(String comment) {
    final newComment = Reaction(
      user: User(data: context.feedClient.currentUser?.data),
      kind: 'comment',
      updatedAt: DateTime.now(),
      data: {'text': comment},
    );

    setState(() {
      _ownComments.insert(0, newComment);
    });

    // Update the comment reaction count in Activity
    final reactionCounts = widget.activity.reactionCounts;
    if (reactionCounts?['comment'] != null) {
      reactionCounts!['comment'] = reactionCounts['comment']! + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: ReactionListCore(
              lookupValue: widget.activity.id!,
              kind: 'comment',
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              emptyBuilder: (context) =>
                  const Center(child: Text('No comment reactions')),
              errorBuilder: (context, error) => Center(
                child: Text(error.toString()),
              ),
              flags: _flags,
              reactionsBuilder: (context, reactions) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: RefreshIndicator(
                    onRefresh: () {
                      return context.feedBloc.refreshPaginatedReactions(
                        widget.activity.id!,
                        flags: _flags,
                      );
                    },
                    child: ListView.separated(
                      itemCount: _ownComments.length + reactions.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        // Shift the index to account for the own comments.
                        if (index < _ownComments.length) {
                          final ownComment = _ownComments[index];
                          return CommentListItem(
                            reaction: ownComment,
                            isOwnComment: true,
                          );
                        }

                        final realIndex = index - _ownComments.length;
                        bool shouldLoadMore = reactions.length - 3 == realIndex;
                        if (shouldLoadMore) {
                          _loadMore();
                        }

                        final reaction = reactions[realIndex];
                        return CommentListItem(
                          reaction: reaction,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          AddCommentBox(
            activity: widget.activity,
            onAddComment: (comment) => _addComment(comment),
          )
        ],
      ),
    );
  }
}
