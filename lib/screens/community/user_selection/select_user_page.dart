import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'demo_user.dart';
import 'user_tile.dart';
import 'home_page.dart';

const tutorialUrl = 'https://getstream.io/activity-feeds/sdk/flutter/tutorial/';

/// Page to connect as one of the [DemoUser]s.
class SelectUserPage extends StatelessWidget {
  const SelectUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(title: const Text('Select user')),
      body: ListView(
        children: demoUsers
            .map(
              (demoUser) => UserTile(
                user: demoUser.user,
                onTap: () async {
                  try {
                    // Connect user
                    await context.feedClient
                        .setUser(demoUser.user, demoUser.token);
                    // Follow own user feed. This ensures the current user's
                    // posts are visible on their "timeline" feed.
                    await context.feedBloc.followFeed(
                      followerFeedGroup: 'timeline',
                      followeeFeedGroup: 'user',
                      followeeId: demoUser.user.id!,
                    );
                    // Navigate to the home page if user connected successfully
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  } on Exception catch (e, st) {
                    log(
                      'Could not connect user. See the tutorial for more details: $tutorialUrl',
                      error: e,
                      stackTrace: st,
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
