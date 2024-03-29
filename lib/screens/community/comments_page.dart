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
    required this.onAddComment,
  }) : super(key: key);

  final EnrichedActivity activity;
  final Function(int) onAddComment;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  bool _isLoading = false;

  List<Reaction> _reactions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _reloadReactions();
  }

  Future<List<Reaction>> _fetchReactions() async {
    await context.feedBloc.refreshPaginatedReactions(
      widget.activity.id!,
      flags: _flags,
    );

    // Delay to allow the refresh to complete, the above refresh is not actually
    // complete when the Future completes.
    await Future.delayed(const Duration(seconds: 2));

    final fetchedReactions = context.feedBloc.getReactions(widget.activity.id!);
    // Only return comments, not likes.
    return fetchedReactions.where((r) => r.kind == 'comment').toList();
  }

  Future<void> _reloadReactions(
      {bool pullToRefresh = false, bool reloadAfterComment = false}) async {
    _isLoading = true;
    if (!pullToRefresh) {
      // No need to show the loading indicator when pull-to-refresh is used.
      setState(() {});
    }

    var reactions = await _fetchReactions();
    if (reactions.isEmpty && reloadAfterComment) {
      // It looks like reactions are not immediately available after adding a
      // new comment, so we wait a bit and retry again.
      // TODO: Investigate why this is happening.
      reactions = await _fetchReactions();
    }

    setState(() {
      _isLoading = false;
      _reactions = reactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(title: const Text('Comments')),
        body: Column(children: [
          Expanded(
              child: RefreshIndicator(
            onRefresh: () {
              return _reloadReactions(pullToRefresh: true);
            },
            child: (_isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _reactions.length == 0
                    ? Center(child: Text("No comments yet, be the first!"))
                    : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: _reactions.map((e) {
                        return CommentListItem(
                          key: ValueKey(e.id),
                          reaction: e,
                        );
                      }).toList(),
                    )
          )),
          AddCommentBox(
              activity: widget.activity,
              onAddComment: (reaction) {
                if(reaction != null) {
                  setState(() {
                    _reactions.insert(0, reaction);
                  });
                  widget.onAddComment(_reactions.length);
                }
              })
        ]));
  }
}
