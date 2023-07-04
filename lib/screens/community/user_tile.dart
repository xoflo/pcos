import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///
/// Optional: [onTap] callback and [trailing] widget.
class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.user,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final User user;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          CircleAvatar(backgroundImage: NetworkImage('')), //user.profileImage
      title: Text(''), //user.fullName
      onTap: onTap,
      trailing: trailing,
    );
  }
}
