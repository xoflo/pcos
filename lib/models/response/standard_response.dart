import 'package:thepcosprotocol_app/models/token.dart';

class StandardResponse {
  final String status;
  final String message;
  final String info;
  final Map<String, dynamic> payload;

  StandardResponse({this.status, this.message, this.info, this.payload});

  factory StandardResponse.fromJson(Map<String, dynamic> json) {
    return StandardResponse(
      status: json['status'],
      message: json['message'],
      info: json['info'],
      payload: json['payload'],
    );
  }
}
