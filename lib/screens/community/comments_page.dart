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

  Future<void> _reloadReactions({bool reloadAfterComment = false}) async {
    setState(() {
      _isLoading = true;
    });

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
              return _reloadReactions();
            },
            child: (_isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _reactions.length == 0
                    ? Center(child: Text("No available comment"))
                    : ListView.separated(
                        itemCount: _reactions.length,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => CommentListItem(
                              reaction: _reactions[index],
                            )),
          )),
          AddCommentBox(
              activity: widget.activity,
              onAddComment: () => _reloadReactions(reloadAfterComment: true))
        ]));
  }
}
