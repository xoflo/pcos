import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app_user.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    required this.activity,
    Key? key,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final user = activity.actor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(user ?? 'Unknown user'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user ?? 'Unknown user',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Shared an update ${timeago.format(
                        activity.time!,
                        allowFromNow: true,
                      )}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            activity.object.toString(),
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Activity>('activity', activity));
  }
}
