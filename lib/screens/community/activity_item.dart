import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'comments_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/activity_details.dart';

/// UI widget to display an activity/post.
///
/// Shows the number of likes and comments.
///
/// Enables the current [User] to like the activity, and view comments.

enum ActivityType { like, comment }

class ActivityItem extends StatefulWidget {
  const ActivityItem(
      {Key? key,
      required this.activityDetail,
      required this.activity,
      this.reaction,
      this.feedGroup})
      : super(key: key);

  final ActivityDetail activityDetail;
  final EnrichedActivity activity;
  final String? feedGroup;
  final Reaction? reaction;

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityItem> {
  // List<Attachment>? attachments = [];
  int? likeCount;
  int? commentCount;
  Map<String, List<Reaction>>? ownReactions;
  bool isLikedByUser = false;

  Reaction? ownLikeReaction;

  Future<void> _unlikePostFormTimeline(Reaction likeReaction) async {
    context.feedBloc.onRemoveReaction(
      kind: 'like',
      activity: widget.activity,
      reaction: likeReaction,
      feedGroup: widget.activityDetail.feedGroup!,
    );
  }

  Future<void> _unlikePostFromComment(Reaction likedReaction) async {
    FeedProvider.of(context).bloc.onRemoveChildReaction(
          kind: 'like',
          childReaction: likedReaction,
          lookupValue: widget.activityDetail.reaction!.id!,
          parentReaction: widget.activityDetail.reaction!,
        );
  }

  Future<void> _likePostFromTimeline() async {
    context.feedBloc
        .onAddReaction(
            kind: 'like',
            activity: widget.activity,
            feedGroup: widget.activityDetail.feedGroup!)
        .then((value) => ownLikeReaction = value);
  }

  Future<void> _likePostFromComment() async {
    FeedProvider.of(context)
        .bloc
        .onAddChildReaction(
          kind: 'like',
          reaction: widget.activityDetail.reaction!,
          lookupValue: widget.activityDetail.reaction!.id!,
        )
        .then((value) => ownLikeReaction = value);
  }

  @override
  void initState() {
    super.initState();
    likeCount = widget.activityDetail.reactionCount?['like'];
    commentCount = widget.activityDetail.reactionCount?['comment'];
    ownReactions = widget.activityDetail.ownReaction;
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
                      "@" + widget.activityDetail.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      '  ${timeago.format(
                        widget.activityDetail.datePosted!,
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
                          widget.activityDetail.postedMessage ?? '',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ))
                ],
              ),
              if (widget.activityDetail.attachement != null &&
                  widget.activityDetail.attachement!.isNotEmpty)
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            widget.activityDetail.attachement![0].url),
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
                        List<Reaction>? likedReactions = ownReactions!['like'];
                        if (likedReactions == null && ownLikeReaction != null) {
                          // If the user has liked the activity, but the like
                          // reaction is not in the original ownReactions list,
                          // because the like reaction `ownLikeReaction` was
                          // added after the initial load, we add it to the
                          // to-be-removed list.
                          likedReactions = [ownLikeReaction!];
                        }

                        if (likedReactions != null &&
                            likedReactions.isNotEmpty) {
                          if (widget.activityDetail.activitySource ==
                              ActivitySource.timeline) {
                            _unlikePostFormTimeline(likedReactions[0]);
                          } else {
                            _unlikePostFromComment(likedReactions[0]);
                          }
                        }
                      } else {
                        if (widget.activityDetail.activitySource ==
                            ActivitySource.timeline) {
                          _likePostFromTimeline();
                        } else {
                          _likePostFromComment();
                        }
                      }

                      // Optimistically like or unlike the activity.
                      setState(() {
                        isLikedByUser = !isLikedByUser;
                        int curLikes = likeCount ?? 0;
                        if (!isLikedByUser) {
                          likeCount = (curLikes - 1);
                        } else {
                          likeCount = (curLikes + 1);
                        }
                      });
                    },
                    color: backgroundColor,
                    icon: isLikedByUser
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                  ),
                  if (likeCount != null)
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
                        child: Text(
                          _displayNumberByActivity(
                              likeCount, ActivityType.like),
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                ],
              ),
              Visibility(
                  visible: widget.activityDetail.activitySource ==
                      ActivitySource.timeline,
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 25,
                        onPressed: () => _navigateToCommentPage(context),
                        icon: const Icon(
                          Icons.message_outlined,
                          color: backgroundColor,
                        ),
                      ),
                      if (commentCount != null)
                        Text(
                          _displayNumberByActivity(
                              commentCount, ActivityType.comment),
                          style: Theme.of(context).textTheme.caption,
                        )
                    ],
                  ))
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
    if (count != null && count > 0) {
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
