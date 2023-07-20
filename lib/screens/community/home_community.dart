import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

import 'timeline_screen.dart';

class HomeCommunity extends StatefulWidget {
  const HomeCommunity({
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  final StreamUser currentUser;

  @override
  _HomeCommunityState createState() => _HomeCommunityState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamUser>('currentUser', currentUser));
  }
}

class _HomeCommunityState extends State<HomeCommunity> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: const [
              Text('Timeline'),
            ],
          ),
        ),
        body: IndexedStack(
            index: _currentIndex,
            children: [TimelineScreen(currentUser: widget.currentUser)]));
  }
}
