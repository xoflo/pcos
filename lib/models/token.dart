import 'package:thepcosprotocol_app/models/profile.dart';

class Token {
  final String accessToken;
  final String refreshToken;
  final Profile profile;

  Token({this.accessToken, this.refreshToken, this.profile});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        profile: Profile.fromJson(json['profile']));
  }
}
