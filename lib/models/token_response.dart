import 'package:thepcosprotocol_app/models/token.dart';

class TokenResponse {
  final String status;
  final String message;
  final String info;
  final Token token;

  TokenResponse({this.status, this.message, this.info, this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
        status: json['status'],
        message: json['message'],
        info: json['info'],
        token: Token.fromJson(json['payload']));
  }
}
