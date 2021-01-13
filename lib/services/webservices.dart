import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/models/standard_response.dart';
import 'package:thepcosprotocol_app/models/token_response.dart';
import 'package:thepcosprotocol_app/models/token.dart';
import 'package:thepcosprotocol_app/models/recipe_response.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/controllers/authentication.dart';

class WebServices {
  final String _baseUrl = FlavorConfig.instance.values.baseUrl;

  Future<Token> signIn(String emailAddress, String password) async {
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
    final String token = await Authentication().getAccessToken();

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
}
