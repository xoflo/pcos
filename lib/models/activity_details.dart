import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

enum ActivitySource { timeline, comment }

class ActivityDetail {
  final String username;
  final DateTime? datePosted;
  final String? postedMessage;
  final List<Attachment>? attachement;
  final Map<String, List<Reaction>>? ownReaction;
  final Map<String, int>? reactionCount;
  final ActivitySource activitySource;
  final String? feedGroup;
  final Reaction? reaction;

  ActivityDetail(
      {required this.username,
      this.datePosted,
      this.postedMessage,
      this.attachement,
      this.ownReaction,
      this.reactionCount,
      required this.activitySource,
      this.feedGroup,
      this.reaction});
}
