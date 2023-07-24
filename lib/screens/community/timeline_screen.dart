import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:thepcosprotocol_app/screens/community/list_activity_item.dart';

import '../../styles/colors.dart';
import 'compose_activity_page.dart';
import 'extension.dart';

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
  bool _isLoading = true;
  List<GenericEnrichedActivity> activities = <GenericEnrichedActivity>[];

  final _feedGroup = 'public';
  final _userId = 'all';

  final feedsLimit = 10;
  int feedsOffset = 0;

  late final Subscription _feedSubscription;

  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  Future<void> _listenToFeed() async {
    _feedSubscription = await _client
        .flatFeed(_feedGroup, _userId)
        // ignore: avoid_print
        .subscribe(print);
  }

  Future<void> _loadActivities({bool pullToRefresh = false}) async {
    if (!pullToRefresh) setState(() => _isLoading = true);
    final userFeed = _client.flatFeed(_feedGroup, _userId);
    PaginatedActivities data = await userFeed
        .getPaginatedEnrichedActivities<User, String, String, String>(
            limit: feedsLimit, offset: feedsOffset, flags: _flags)
        .then((value) {
      feedsOffset = feedsOffset + feedsLimit;
      return value;
    });
    if (!pullToRefresh) _isLoading = false;
    setState(() => activities.addAll(data.results ?? []));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = context.client;
    _listenToFeed();
    _loadActivities();
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
      body: RefreshIndicator(
        onRefresh: () => _loadActivities(pullToRefresh: true),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : activities.isEmpty
                ? Column(
                    children: [
                      const Text('No activities yet!'),
                      ElevatedButton(
                        onPressed: _loadActivities,
                        child: const Text('Reload'),
                      )
                    ],
                  )
                : ListView.separated(
                    itemCount: activities.length,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final actor = activities[index].actor;
                      return ListActivityItem(
                        user: actor?.data?['user_name'].toString() ?? '',
                        activity: activities[index] as GenericEnrichedActivity<
                            User, String, String, String>,
                        feedGroup: _feedGroup,
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const ComposeActivityPage()),
          );
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        IterableProperty<GenericEnrichedActivity>('activities', activities));
  }
}
