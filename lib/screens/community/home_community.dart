import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

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
    final feedClient = context.feedClient;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarIconBrightness: Brightness.light),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Column(
                children: const [
                  Text('Timeline'),
                ],
              ),
            ),
          body: SafeArea(
              child: IndexedStack(index: _currentIndex, children: [
                TimelineScreen(
                    feedClient: feedClient, currentUser: widget.currentUser)
              ]),
            ),
        ),
      ),
    );
  }
}
