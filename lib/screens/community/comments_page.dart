import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'add_comment_box.dart';

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

  TextEditingController textController = TextEditingController();
  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  final _formKey = GlobalKey<FormState>();

  final isTextFieldVisible = ValueNotifier(false);
  int timesChanged = 0;
  String txtValue = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      isTextFieldVisible.value = true;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _client = context.feedClient;
  //   _loadActivities();
  //   _listenToFeed();
  // }

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

  Future<void> _removeWidget() async {
    // _addComment();
    // txtValue = textController.text;
    // textController.clear();
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      isTextFieldVisible.value = false;
    });
  }

  // Future<void> _addComment() async {
  Future<Reaction> _addComment() async {
    txtValue = textController.text;

    // if (txtValue.isNotEmpty) {
    if (true) {
      FocusManager.instance.primaryFocus?.unfocus();

      return FeedProvider.of(context).bloc.onAddReaction(
        kind: 'comment',
        activity: widget.activity,
        feedGroup: 'public',
        // data: {'text': txtValue},
        data: {'text': 'txt value 17'},
      );
    }
  }

  Future<void> _addOrRemoveLike(Reaction reaction) async {
    final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;
    if (isLikedByUser) {
      FeedProvider.of(context).bloc.onRemoveChildReaction(
            kind: 'like',
            childReaction: reaction.ownChildren!['like']![0],
            lookupValue: widget.activity.id!,
            parentReaction: reaction,
          );
    } else {
      FeedProvider.of(context).bloc.onAddChildReaction(
            kind: 'like',
            reaction: reaction,
            lookupValue: widget.activity.id!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return newMethod2();
  }

  Scaffold newMethod2() {
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
                      child: newMethod(reactions)),
                );
              },
            ),
          ),
          // AddCommentBox(activity: widget.activity)

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 32),

            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: isTextFieldVisible,
                    builder: (context, value, child) {
                      if (value == false) {
                        textController.dispose();
                        textController = TextEditingController();
                        
                        FocusManager.instance.primaryFocus?.unfocus();
                        return Text('Posting...');
                      } else {
                        return Form(
                          key: _formKey,
                          child: TextField(
                            controller: textController,
                            // onSubmitted: ((value) {
                            //   // _addComment();
                            // }),
                            decoration: InputDecoration(
                              hintText: 'Add a comment',
                              // suffix: IconButton(
                              //   onPressed: _removeWidget,
                              //   icon: const Icon(Icons.send),
                              // ),
                            ),
                          ),
                        );
                      }
                      // return Text('');
                    }),
                IconButton(
                    icon: const Icon(Icons.send),
                    // onPressed: _removeWidget,
                    onPressed: () {
                      _removeWidget().then((value) {
                        _addComment().then((value) {
                          Future.delayed(Duration(seconds: 3));
                          context.feedBloc.refreshPaginatedReactions(
                            widget.activity.id!,
                            flags: _flags,
                          );

                          context.feedBloc
                              .loadMoreReactions(widget.activity.id!, flags: _flags);
                          setState(() {
                            isTextFieldVisible.value = true;
                          });
                        });
                      });
                    }
                    )
              ],
            ),
            // child: IconButton(icon: const Icon(Icons.send), onPressed: _addComment,)
          )
        ],
      ),
    );
  }

  ListView newMethod(List<Reaction> reactions) {
    return ListView.separated(
      itemCount: reactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        bool shouldLoadMore = reactions.length - 3 == index;
        if (shouldLoadMore) {
          _loadMore();
        }

        final reaction = reactions[index];
        final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;

        return ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${reaction.data?['text']}',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          trailing: IconButton(
            iconSize: 14,
            onPressed: () {
              _addOrRemoveLike(reaction);
            },
            icon: isLikedByUser
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
          ),
        );
      },
    );
  }
}
