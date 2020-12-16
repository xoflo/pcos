import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/models/token_response.dart';
import 'package:thepcosprotocol_app/models/token.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';

class WebServices {
  final String baseUrl = FlavorConfig.instance.values.baseUrl;

  Future<Token> signIn(String emailAddress, String password) async {
    final url = baseUrl + "token";
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'alias': emailAddress, 'password': password},
      ),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      debugPrint("BODY=${response.body}");
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      debugPrint("accessToken=${tokenResponse.token.accessToken}");
      //final token = Token.fromJson(jsonDecode(apiResponse.payload));
      //debugPrint("TOKEN=${token.accessToken}");
      //final myToken = Token.fromJson(apiResponse.payload);
      return tokenResponse.token;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(SIGN_IN_FAILED);
    }
  }
}
