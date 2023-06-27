import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// A class for demonstration purposes, to allow hardcoded users and tokens.
class DemoUser {
  final User user;
  final Token token;

  const DemoUser({
    required this.user,
    required this.token,
  });
}

/// List of hardcoded [DemoUser]s.
///
/// Do not hardcode [Token]s in a production environment. See our
/// [documentation on user tokens](https://getstream.io/activity-feeds/docs/flutter-dart/auth_and_permissions/?language=dart#user-tokens).
///
/// You can generate a token using any of our [backend SDKs](https://getstream.io/chat/sdk/#backend-clients),
/// manually using our [online token generator](https://getstream.io/chat/docs/react/token_generator/),
/// or using the [stream-cli](https://github.com/GetStream/stream-cli).
const demoUsers = [
  DemoUser(
    user: User(
      id: 'nicks_test',
      data: {
        'handle': '@Nicks',
        'first_name': 'Nicks',
        'last_name': 'Villa',
        'full_name': 'Nicks Villa',
        'profile_image': 'https://avatars.githubusercontent.com/u/18029834?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibmlja3NfdGVzdCJ9.4Zy1RKxyeQTZ5AufgaV2bCrfrZ5hGjZ5dJkR5bT4FmE'),
  )
];

/// An extension method on Stream's [User] class - to easily access user data
/// properties used in this sample application.
extension UserData on User {
  String get handle => data?['handle'] as String? ?? '';
  String get firstName => data?['first_name'] as String? ?? '';
  String get lastName => data?['last_name'] as String? ?? '';
  String get fullName => data?['full_name'] as String? ?? '';
  String get profileImage => data?['profile_image'] as String? ?? '';
}
