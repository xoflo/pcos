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
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';

class WebServices {
  final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  //Authentication

  Future<Token> signIn(final String emailAddress, final String password) async {
    final url = _baseUrl + "Token";
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'alias': emailAddress, 'password': password},
      ),
    );
    debugPrint("LOGIN RESPOMSE=${response.body}");
    debugPrint("STATUS CODE=${response.statusCode}");

    if (response.statusCode == 200) {
      final String responseBody = response.body;
      if (responseBody.toLowerCase().contains("fail")) {
        if (responseBody.toLowerCase().contains("email address not verified")) {
          debugPrint("HERE1");
          throw EMAIL_NOT_VERIFIED;
        } else {
          debugPrint("HERE2");
          throw SIGN_IN_FAILED;
        }
      }
      debugPrint("HERE4");
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      return tokenResponse.token;
    } else {
      debugPrint("HERE3");
      throw SIGN_IN_CREDENTIALS;
    }
  }

  Future<Token> refreshToken() async {
    final url = _baseUrl + "Token/refresh";
    final String token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String>{token},
      ),
    );

    if (response.statusCode == 200) {
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      return tokenResponse.token;
    } else {
      throw Exception(SIGN_IN_FAILED);
    }
  }

  //Member

  Future<Member> getMemberDetails() async {
    final url = _baseUrl + "Member/me";
    final String token = await AuthenticationController().getAccessToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    debugPrint("***********************ALL RESPONSE ${response.body}");

    if (response.statusCode == 200) {
      return Member.fromJson(
          StandardResponse.fromJson(jsonDecode(response.body)).payload);
    } else {
      throw Exception(GET_MEMBER_FAILED);
    }
  }

  Future<bool> updateMemberDetails(final String encodedMemberDetails) async {
    final url = _baseUrl + "account_services/update_profile";
    final String token = await AuthenticationController().getAccessToken();
    debugPrint("**********ENCODED=$encodedMemberDetails");

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: encodedMemberDetails,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(UPDATE_MEMBER_FAILED);
    }
  }

  //Recipes

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

  //CMS

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
