import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'comments_page.dart';
import 'package:timeago/timeago.dart' as timeago;

/// UI widget to display an activity/post.
///
/// Shows the number of likes and comments.
///
/// Enables the current [User] to like the activity, and view comments.

enum ActivityType { like, comment }

class ListActivityItem extends StatefulWidget {
  const ListActivityItem(
      {Key? key,
      required this.user,
      required this.activity,
      required this.feedGroup})
      : super(key: key);

  final EnrichedActivity activity;
  final String feedGroup;
  final String user;

  @override
  _ListActivityItemState createState() => _ListActivityItemState();
}

class _ListActivityItemState extends State<ListActivityItem> {
  List<Attachment>? attachments = [];
  Map<String, int>? reactionCounts;
  Map<String, List<Reaction>>? ownReactions;
  bool isLikedByUser = false;

  @override
  void initState() {
    super.initState();
    attachments = (widget.activity.extraData)?.toAttachments();
    reactionCounts = widget.activity.reactionCounts;
    ownReactions = widget.activity.ownReactions;
    isLikedByUser = (ownReactions?['like']?.length ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
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
                      "@" + widget.user,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      '  ${timeago.format(
                        widget.activity.time!,
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
                          left: 20, top: 10, right: 20, bottom: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(
                          '${widget.activity.object}',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ))
                ],
              ),
              if (attachments != null && attachments!.isNotEmpty)
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(attachments![0].url),
                      ),
                    )),
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
                          activity: widget.activity,
                          reaction: ownReactions!['like']![0],
                          feedGroup: widget.feedGroup,
                        );
                      } else {
                        context.feedBloc.onAddReaction(
                            kind: 'like',
                            activity: widget.activity,
                            feedGroup: widget.feedGroup);
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
                    },
                    color: backgroundColor,
                    icon: isLikedByUser
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                  ),
                  if (reactionCounts?['like'] != null)
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
                        child: Text(
                          _displayNumberByActivity(
                              reactionCounts?['like'], ActivityType.like),
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 25,
                    onPressed: () => _navigateToCommentPage(context),
                    icon: const Icon(
                      Icons.message_outlined,
                      color: backgroundColor,
                    ),
                  ),
                  if (reactionCounts?['comment'] != null)
                    Text(
                      _displayNumberByActivity(
                          reactionCounts?['comment'], ActivityType.comment),
                      style: Theme.of(context).textTheme.caption,
                    )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => CommentsPage(
                activity: widget.activity,
              ),
          fullscreenDialog: true),
    );
  }

  String _displayNumberByActivity(int? count, ActivityType type) {
    if (count != null) {
      String displayText = getDisplayTextActivity(type);
      String displayTextActivity = count > 1 ? displayText + "s" : displayText;
      return '$count' + " " + displayTextActivity;
    } else {
      return "";
    }
  }

  String getDisplayTextActivity(ActivityType type) {
    switch (type) {
      case ActivityType.like:
        return "Like";
      case ActivityType.comment:
        return "Comment";
      default:
        return "";
    }
  }
}
