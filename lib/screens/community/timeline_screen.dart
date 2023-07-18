import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';

import 'list_activity_item.dart';
import 'package:provider/provider.dart';

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
  Subscription? _feedSubscription;

  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'public';

  Future<void> _listenToFeed() async {
      if (_feedSubscription == null) {
        _feedSubscription = await _client
            .flatFeed('public', 'all')
            .subscribe(print);
      }
  }

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreEnrichedActivities(feedGroup: _feedGroup, userId: 'all', flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  List<Activity> activities = <Activity>[];

  Future<void> _loadActivities({bool pullToRefresh = false}) async {
    if (!pullToRefresh) setState(() => isLoading = true);

    final userFeed = _client.flatFeed('public', 'all');
    final data = await userFeed.getActivities();
    if (!pullToRefresh) isLoading = false;
    setState(() => activities = data);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = context.feedClient;
    // _listenToFeed();
    _loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: FlatFeedCore(
        feedGroup: _feedGroup,
        userId: 'all',
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No activities')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        limit: 3,
        flags: _flags,
        feedBuilder: (
          BuildContext context,
          activities,
        ) {
          return RefreshIndicator(
            onRefresh: () {
              return context.feedBloc.refreshPaginatedEnrichedActivities(
                feedGroup: _feedGroup,
                userId: 'all',
                flags: _flags,
              );
            },
            child: ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                bool shouldLoadMore = activities.length - 3 == index;
                if (shouldLoadMore) {
                  _loadMore();
                }
                return ListActivityItem(
                  user: memberProvider.firstName,
                  activity: activities[index],
                  feedGroup: _feedGroup,
                );
              },
            ),
          );
        },
      )
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Activity>('activities', activities));
  }
}
