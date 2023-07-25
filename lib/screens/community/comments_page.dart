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
  bool _isPaginating = false;

  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  List<Reaction> reactions = [];

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

  Future<void> updateReactions(List<Reaction> reaction) async {
    await context.feedBloc.refreshPaginatedReactions(
      widget.activity.id!,
      flags: _flags,
    );

    setState(() {
      reactions = reaction;
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
              return updateReactions(
                  context.feedBloc.getReactions(widget.activity.id!));

              // context.feedBloc.refreshPaginatedReactions(
              //   widget.activity.id!,
              //   flags: _flags,
              // );
            },
            child: ListView.separated(
                itemCount: reactions.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final reaction = reactions[index];
                  return CommentListItem(
                    reaction: reaction,
                  );
                }),
          )),
          AddCommentBox(activity: widget.activity)
        ])

        //   Column(
        // children: [
        //   Expanded(
        //       child: ReactionListCore(
        //         lookupValue: widget.activity.id!,
        //         kind: 'comment',
        //         loadingBuilder: (context) => const Center(
        //           child: CircularProgressIndicator(),
        //         ),
        //         emptyBuilder: (context) =>
        //             const Center(child: Text('No comment reactions')),
        //         errorBuilder: (context, error) => Center(
        //           child: Text(error.toString()),
        //         ),
        //         flags: _flags,
        //         reactionsBuilder: (context, reactions) {
        //           return Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //             child: RefreshIndicator(
        //               onRefresh: () {
        //                 print("Reactions after refresh List total");
        //                 print(context.feedBloc
        //                     .getReactions(widget.activity.id!)
        //                     .length);

        //                 reactions =
        //                     context.feedBloc.getReactions(widget.activity.id!);

        //                 print("Reactions after refresh List");
        //                 print(reactions);

        //                 return context.feedBloc.refreshPaginatedReactions(
        //                   widget.activity.id!,
        //                   flags: _flags,
        //                 );
        //               },
        //               child: ListView.separated(
        //                 itemCount: reactions.length,
        //                 separatorBuilder: (context, index) => const Divider(),
        //                 itemBuilder: (context, index) {
        //                   bool shouldLoadMore = reactions.length - 3 == index;
        //                   if (shouldLoadMore) {
        //                     _loadMore();
        //                   }

        //                   final reaction = reactions[index];
        //                   return CommentListItem(
        //                     reaction: reaction,
        //                   );
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //     AddCommentBox(activity: widget.activity)
        //   ],
        // ),
        );
  }
}
