import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:thepcosprotocol_app/screens/community/list_activity_item.dart';

import '../../styles/colors.dart';
import 'compose_activity_page.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({
    required this.feedClient,
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  final StreamFeedClient feedClient;
  final StreamUser currentUser;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamUser>('currentUser', currentUser));
  }
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool _isLoading = true;
  List<EnrichedActivity> activities = [];

  final _feedGroup = 'public';
  final _userId = 'all';

  static int feedsLimit = 10;

  bool _isLoadingMore = false;
  int _feedOffset = 0;

  Subscription? _feedSubscription;

  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  @override
  void initState() {
    super.initState();

    _listenToFeed();
    _reloadActivities(pullToRefresh: false);
  }

  Future<void> _listenToFeed() async {
    if (_feedSubscription == null) {
      _feedSubscription = await widget.feedClient
          .flatFeed(_feedGroup, _userId)
          // ignore: avoid_print
          .subscribe(print);
    }
  }

  Future<List<EnrichedActivity>> _loadPaginatedActivities(int offset) async {
    final userFeed = widget.feedClient.flatFeed(_feedGroup, _userId);

    final paginated = await userFeed
        .getPaginatedEnrichedActivities<User, String, String, String>(
            offset: offset, limit: feedsLimit, flags: _flags);

    _feedOffset = offset;

    return paginated.results ?? [];
  }

  Future<void> _reloadActivities({bool pullToRefresh = false}) async {
    if (!pullToRefresh) setState(() => _isLoading = true);
    final loadedActivities = await _loadPaginatedActivities(0);
    if (!pullToRefresh) _isLoading = false;
    setState(() => activities = loadedActivities);
  }

  // Load more activities and append them to the list of activities.
  Future<void> _loadMoreActivities() async {
    if (!_isLoadingMore) {
      _isLoadingMore = true;

      try {
        final paginated = await _loadPaginatedActivities(_feedOffset);
        _feedOffset = _feedOffset + paginated.length;

        setState(() => activities.addAll(paginated));
      } finally {
        _isLoadingMore = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _feedSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: RefreshIndicator(
        onRefresh: () => _reloadActivities(pullToRefresh: true),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : activities.isEmpty
                ? Column(
                    children: [
                      const Text('No activities yet!'),
                      ElevatedButton(
                        onPressed: _reloadActivities,
                        child: const Text('Reload'),
                      )
                    ],
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: ListView.separated(
                      itemCount: activities.length,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, index) => _paginatedItemBuilder(index),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => ComposeActivityPage(
                      onAddActivity: () =>
                          _reloadActivities(pullToRefresh: false),
                    )),
          );
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Item builder that loads more when the user reaches near the end of the list.
  Widget _paginatedItemBuilder(int index) {
    final nearEndThreshold = 3;

    if (index >= activities.length - nearEndThreshold) {
      _loadMoreActivities();
    }

    return ListActivityItem(
      activity: activities[index],
      feedGroup: _feedGroup,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('activities', activities));
  }
}
