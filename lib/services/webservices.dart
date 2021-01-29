import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/models/knowledge_base.dart';
import 'package:thepcosprotocol_app/models/response/standard_response.dart';
import 'package:thepcosprotocol_app/models/response/list_response.dart';
import 'package:thepcosprotocol_app/models/response/token_response.dart';
import 'package:thepcosprotocol_app/models/response/recipe_response.dart';
import 'package:thepcosprotocol_app/models/response/cms_response.dart';
import 'package:thepcosprotocol_app/models/response/cms_multi_response.dart';
import 'package:thepcosprotocol_app/models/token.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';

class WebServices {
  final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  //Connectivity
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

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

    if (response.statusCode == 200) {
      final String responseBody = response.body;
      if (responseBody.toLowerCase().contains("fail")) {
        if (responseBody.toLowerCase().contains("email address not verified")) {
          throw EMAIL_NOT_VERIFIED;
        } else {
          throw SIGN_IN_FAILED;
        }
      }
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      return tokenResponse.token;
    } else {
      throw SIGN_IN_CREDENTIALS;
    }
  }

  Future<Token> refreshToken() async {
    final url = _baseUrl + "Token/refresh";
    final String refreshToken =
        await AuthenticationController().getRefreshToken();
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "'$refreshToken'",
    );

    if (response.statusCode == 200) {
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      return tokenResponse.token;
    } else {
      throw TOKEN_REFRESH_FAILED;
    }
  }

  Future<bool> forgotPassword(final String emailAddress) async {
    final url = _baseUrl + "account_services/forgot_password";

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: "'$emailAddress'",
    );

    if (response.statusCode == 200) {
      final forgotResponse =
          StandardResponse.fromJson(jsonDecode(response.body));
      if (forgotResponse.status.toLowerCase() == "ok") {
        return true;
      } else {
        return false;
      }
    } else {
      throw FORGOT_PASSWORD_FAILED;
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

    if (response.statusCode == 200) {
      return Member.fromJson(
          StandardResponse.fromJson(jsonDecode(response.body)).payload);
    } else {
      throw GET_MEMBER_FAILED;
    }
  }

  Future<bool> updateMemberDetails(final String encodedMemberDetails) async {
    final url = _baseUrl + "account_services/update_profile";
    final String token = await AuthenticationController().getAccessToken();

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
      throw UPDATE_MEMBER_FAILED;
    }
  }

  Future<bool> resetPassword(
      final String usernameOrEmail, final String newPassword) async {
    final url = _baseUrl + "account_services/reset_password";
    final String token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, String>{
          'id': '0',
          'hash': '',
          'token': '',
          'email': usernameOrEmail,
          'password': newPassword,
          'confirmPassword': newPassword
        },
      ),
    );

    if (response.statusCode == 200) {
      final standardResponse =
          StandardResponse.fromJson(jsonDecode(response.body));
      if (standardResponse.status.toLowerCase() == "fail") {
        throw RESET_PASSWORD_FAILED;
      }
      return true;
    } else {
      throw RESET_PASSWORD_FAILED;
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

  Future<List<CMS>> getCMSByType(final String cmsType) async {
    final url = _baseUrl + "CMS/bytype/$cmsType";
    final String token = await AuthenticationController().getAccessToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return CMSMultiResponse.fromList(
              ListResponse.fromJson(jsonDecode(response.body)).payload)
          .results;
    } else {
      throw GET_CMSBYTYPE_FAILED;
    }
  }
}
