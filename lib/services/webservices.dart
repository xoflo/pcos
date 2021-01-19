import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/models/response/standard_response.dart';
import 'package:thepcosprotocol_app/models/response/token_response.dart';
import 'package:thepcosprotocol_app/models/response/recipe_response.dart';
import 'package:thepcosprotocol_app/models/response/cms_response.dart';
import 'package:thepcosprotocol_app/models/token.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';

class WebServices {
  final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  Future<Token> signIn(final String emailAddress, final String password) async {
    final url = _baseUrl + "token";
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
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      return tokenResponse.token;
    } else {
      throw Exception(SIGN_IN_FAILED);
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    final url = _baseUrl + "recipe/all";
    final String token = await AuthenticationController().getAccessToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return RecipeResponse.fromJson(
              StandardResponse.fromJson(jsonDecode(response.body)).payload)
          .results;
    } else {
      throw Exception(GET_RECIPES_FAILED);
    }
  }

  Future<String> getCmsAssetByReference(final String reference) async {
    final url = _baseUrl + "CMS/asset/$reference";

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return CmsResponse.fromJson(
              StandardResponse.fromJson(jsonDecode(response.body)).payload)
          .body;
    } else {
      throw Exception(GET_PRIVACY_STATEMENT_FAILED);
    }
  }

  Future<String> getFrequentlyAskedQuestions() async {
    final url = _baseUrl + "CMS/all";
    final String token = await AuthenticationController().getAccessToken();
    debugPrint("TOKEN=$token");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    debugPrint("***********************ALL RESPONSE ${response.body}");

    if (response.statusCode == 200) {
      return "got all";
      /*return CmsResponse.fromJson(
              StandardResponse.fromJson(jsonDecode(response.body)).payload)
          .body;*/
    } else {
      debugPrint("*************status=${response.statusCode}");
      return "failed";
    }
  }
}
