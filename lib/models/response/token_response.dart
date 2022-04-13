import 'package:thepcosprotocol_app/models/token.dart';

class TokenResponse {
  final String? status;
  final String? message;
  final String? info;
  final Token? token;

  TokenResponse({this.status, this.message, this.info, this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
        status: json['status'],
        message: json['message'],
        info: json['info'],
        token: Token.fromJson(json['payload']));
  }
}

//example
/*
{
  "status": "OK",
  "message": "",
  "info": "",
  "payload": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJQQ09TU2VydmljZUFjY2Vzc1Rva2VuIiwianRpIjoiMjRjNGZhZjYtYzYzMS00MDAyLTgyZjYtYWQzYjMwZjYyNjM0IiwiaWF0IjoiMDEvMDgvMjAyMSAwMToxOTo0MSIsInBjb3NfbWVtYmVyX2lkIjoiMiIsInBjb3NfaGFzaCI6IjU0MmI0NjFmN2RjMjRmY2Y2YzdiNmRiM2FmNTBkZGNhIiwiZXhwIjoxNjEwMTU1MTgxLCJpc3MiOiJQQ09TQXV0aGVudGljYXRpb25TZXJ2ZXIiLCJhdWQiOiJQQ09TU2VydmljZVBvc3RtYW5DbGllbnQifQ.uKRDpexaM9HA4zqU3JIumh1ZLD8XviX0oXzl5yMNs0w",
    "refreshToken": "PIoVNlvULEXsJ4rVg/LRQdnv+byeqDz7bhHsoCNhJMFGO8aXyp6E0m+UIrBjsYD2B/A1r57+9QB7t9aQPD9rhA==",
    "profile": {
      "id": 2,
      "firstName": "Andy",
      "lastName": "Frost",
      "alias": "andyfrost50",
      "countryID": "",
      "isAdmin": false,
      "dateCreatedUTC": "2020-12-13T23:18:51.08"
    }
  }
}
 */
