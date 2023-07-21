import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'list_activity_item.dart';
import 'compose_activity_page.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  final StreamUser currentUser;

  @override
  _TimelineScreenState createState() => _TimelineScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamUser>('currentUser', currentUser));
  }
}

class _TimelineScreenState extends State<TimelineScreen> {
  late StreamFeedClient _client;
  bool isLoading = true;

  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'public';
  static const _userId = 'all';

  late final Subscription _feedSubscription;

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreEnrichedActivities(
              feedGroup: _feedGroup, userId: _userId, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  List<Activity> activities = <Activity>[];

  Future<void> _listenToFeed() async {
    _feedSubscription = await _client
        .flatFeed(_feedGroup, _userId)
        // ignore: avoid_print
        .subscribe(print);

        // _feedSubscription = await _client
        // .reactions.(_feedGroup, _userId)
        // // ignore: avoid_print
        // .subscribe(print);
  }

  Future<void> _loadActivities({bool pullToRefresh = false}) async {
    if (!pullToRefresh) {
      setState(() => isLoading = true);
    }

    final userFeed = _client.flatFeed(_feedGroup, _userId);
    final data = await userFeed.getActivities();
    if (!pullToRefresh) {}
    setState(() {
      activities = data;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = context.feedClient;
    _loadActivities();
    _listenToFeed();
  }

  @override
  void dispose() {
    super.dispose();
    _feedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: FlatFeedCore(
        feedGroup: _feedGroup,
        userId: _userId,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No activities')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        limit: 10,
        flags: _flags,
        feedBuilder: (
          BuildContext context,
          activities,
        ) {
          return RefreshIndicator(
            onRefresh: () {
              return context.feedBloc.refreshPaginatedEnrichedActivities(
                feedGroup: _feedGroup,
                userId: _userId,
                flags: _flags,
              );
            },
            child: ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final shouldLoadMoreThreshold = 3;
                bool shouldLoadMore =
                    activities.length - shouldLoadMoreThreshold == index;
                if (shouldLoadMore) {
                  _loadMore();
                }
                final actor = activities[index].actor;
                return ListActivityItem(
                  user: actor?.data?['user_name'].toString() ?? '',
                  activity: activities[index],
                  feedGroup: _feedGroup,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const ComposeActivityPage()),
          ).then((value) => _loadActivities(pullToRefresh: false));
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Activity>('activities', activities));
  }
}
