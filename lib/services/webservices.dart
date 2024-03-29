import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/constants/exceptions.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:thepcosprotocol_app/models/cms.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_task.dart';
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/module_export.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/models/response/cms_multi_response.dart';
import 'package:thepcosprotocol_app/models/response/cms_response.dart';
import 'package:thepcosprotocol_app/models/response/lesson_complete_response.dart';
import 'package:thepcosprotocol_app/models/response/lesson_response.dart';
import 'package:thepcosprotocol_app/models/response/lesson_task_response.dart';
import 'package:thepcosprotocol_app/models/response/list_response.dart';
import 'package:thepcosprotocol_app/models/response/message_response.dart';
import 'package:thepcosprotocol_app/models/response/module_export_response.dart';
import 'package:thepcosprotocol_app/models/response/module_response.dart';
import 'package:thepcosprotocol_app/models/response/recipe_response.dart';
import 'package:thepcosprotocol_app/models/response/standard_response.dart';
import 'package:thepcosprotocol_app/models/response/token_response.dart';
import 'package:thepcosprotocol_app/models/token.dart';
import 'package:thepcosprotocol_app/models/workout_exercise.dart';
import 'package:thepcosprotocol_app/models/workout_exercise_list.dart';

import '../models/response/getstreamio_token_response.dart';
import '../models/response/workout_response.dart';
import '../models/workout.dart';
import '../utils/device_utils.dart';

class WebServices {
  // ignore: todo
  // TODO: would be better if this is private but right now we need this to be mockable
  String get baseUrl => FlavorConfig.instance.values.baseUrl;

  static Map<String, String> kWebServicesHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Future initHeaders() async {
    kWebServicesHeaders = await DeviceUtils().getWebServiceHeaders();
  }

  //#region Connectivity
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  //#endregion

  //#region Authentication
  Future<Token?> signIn(
      final String emailAddress, final String password) async {
    final url = Uri.parse(baseUrl + "Token");
    final response = await http.post(
      url,
      headers: kWebServicesHeaders,
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

  Future<Token?> refreshToken() async {
    final url = Uri.parse(baseUrl + "Token/refresh");
    final String? refreshToken =
        await AuthenticationController().getRefreshToken();
    final response = await http.post(
      url,
      headers: kWebServicesHeaders,
      body: "'$refreshToken'",
    );

    if (response.statusCode == 200) {
      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      return tokenResponse.token;
    } else {
      throw TOKEN_REFRESH_FAILED;
    }
  }

  Future<String> getStreamIOToken() async {
    final url = Uri.parse(baseUrl + "token/chat");
    final String? token = await AuthenticationController().getAccessToken();
    try {
      final response = await http.get(url,
      headers: {
        ...kWebServicesHeaders,
        'Authorization': 'Bearer $token',
      });
      final resp = GetStreamIOResponse.fromJson(jsonDecode(response.body));
      return resp.payload ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> forgotPassword(final String emailAddress) async {
    final url = Uri.parse(baseUrl + "account_services/forgot_password");

    final response = await http.post(
      url,
      headers: kWebServicesHeaders,
      body: "'$emailAddress'",
    );

    if (response.statusCode == 200) {
      final forgotResponse =
          StandardResponse.fromJson(jsonDecode(response.body));
      if (forgotResponse.status?.toLowerCase() == "ok") {
        return true;
      } else {
        return false;
      }
    } else {
      throw FORGOT_PASSWORD_FAILED;
    }
  }
  //#endregion

  //#region Member
  Future<Member> getMemberDetails() async {
    final url = Uri.parse(baseUrl + "Member/me");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return Member.fromJson(
            StandardResponse.fromJson(jsonDecode(response.body)).payload ?? {});
      } else {
        throw GET_MEMBER_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteMember() async {
    final url = Uri.parse(baseUrl + "Member");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw SET_MEMBER_WHY_FAILED;
    }
  }

  Future<dynamic> executeHttpGet(url) async {
    final String? token = await AuthenticationController().getAccessToken();
    try {
      final response = await http.get(url, headers: {
        ...kWebServicesHeaders,
        'Authorization': 'Bearer $token',
      });

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> executeHttpGetWithoutAuth(url) async {
    final response = await http.get(url, headers: kWebServicesHeaders);

    return response;
  }

  Future<bool> setMemberWhy(String memberId, String why) async {
    final url = Uri.parse(baseUrl + "Member/setwhatsmywhy");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, String>{'MemberId': memberId, 'StringValue': why},
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw SET_MEMBER_WHY_FAILED;
    }
  }

  Future<bool> updateMemberDetails(final String encodedMemberDetails) async {
    final url = Uri.parse(baseUrl + "account_services/update_profile");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: <String, String>{
        ...kWebServicesHeaders,
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
    final url = Uri.parse(baseUrl + "account_services/reset_password");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: <String, String>{
        ...kWebServicesHeaders,
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
      if (standardResponse.status?.toLowerCase() == "fail") {
        throw RESET_PASSWORD_FAILED;
      }
      return true;
    } else {
      throw RESET_PASSWORD_FAILED;
    }
  }
  //#endregion

  //#region Course
  Future<List<ModuleExport>?> getModulesExport() async {
    final url = Uri.parse(baseUrl + "Module/export");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        //log(response.body);
        return ModuleExportResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw Exception(GET_MODULES_FAILED);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Module>?> getAllModules() async {
    final url = Uri.parse(baseUrl + "Module/all");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return ModuleResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw Exception(GET_MODULES_FAILED);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Module>?> getIncompleteModules() async {
    final url = Uri.parse(baseUrl + "Module/incomplete");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return ModuleResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw Exception(GET_MODULES_FAILED);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Module>?> getCompleteModules() async {
    final url = Uri.parse(baseUrl + "Module/complete");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return ModuleResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw Exception(GET_MODULES_FAILED);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setModuleComplete(final int moduleId) async {
    final url = Uri.parse(baseUrl + "Module/set-completed");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: {
        ...kWebServicesHeaders,
        'Authorization': 'Bearer $token',
      },
      body: moduleId.toString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  Future<DateTime> setLessonComplete(final int lessonId) async {
    final url = Uri.parse(baseUrl + "Lesson/set-completed");
    final String? token = await AuthenticationController().getAccessToken();

    //get next midnight, in UTC
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tonightMidnightUTC =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day).toUtc();

    final response = await http.post(
      url,
      headers: {
        ...kWebServicesHeaders,
        'Authorization': 'Bearer $token',
      },
      body:
          "{'lessonID': $lessonId,'localMidnightUTC': '${tonightMidnightUTC.toIso8601String()}'}",
    );

    if (response.statusCode == 200) {
      String nextLessonDateString =
          LessonCompleteResponse.fromJson(jsonDecode(response.body)).payload ??
              "";
      if (!nextLessonDateString.endsWith("Z")) {
        nextLessonDateString = "${nextLessonDateString}Z";
      }
      return DateTime.parse(nextLessonDateString).toLocal();
    } else {
      throw SET_LESSON_COMPLETE_FAILED;
    }
  }

  Future<bool> setTaskComplete(final int? taskId, final String value) async {
    final url = Uri.parse(baseUrl + "Task/set-completed/$taskId");
    final String? token = await AuthenticationController().getAccessToken();
    final response = await http.post(
      url,
      headers: {
        ...kWebServicesHeaders,
        'Authorization': 'Bearer $token',
      },
      body: "'$value'",
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw SET_TASK_COMPLETE_FAILED;
    }
  }

  Future<List<Lesson>?> getAllLessonsForModule(final int moduleId) async {
    final url = Uri.parse(baseUrl + "Lesson/all/$moduleId");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return LessonResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_LESSONS_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LessonTask>?> getIncompleteTasks(final int lessonId) async {
    final url = Uri.parse(baseUrl + "Task/incomplete/$lessonId");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return LessonTaskResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_LESSON_TASKS_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LessonTask>?> getTasksForLesson(final int lessonId) async {
    final url = Uri.parse(baseUrl + "Task/all/$lessonId");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return LessonTaskResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_LESSON_TASKS_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LessonTask>?> getQuizTasks() async {
    final url = Uri.parse(baseUrl + "Task/all/quizzes");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return LessonTaskResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_LESSON_QUIZ_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region Recipes
  Future<List<Recipe>?> getAllRecipes() async {
    final url = Uri.parse(baseUrl + "recipe/all");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return RecipeResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_RECIPES_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region Workouts
  Future<List<Workout>?> getAllWorkouts() async {
    final url = Uri.parse(baseUrl + "Workout/export");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return WorkoutResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_WORKOUTS_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  Future<List<WorkoutExercise>?> getExercisesForWorkout(final int workoutID) async {
    final url = Uri.parse(baseUrl + "Exercise/workout/$workoutID");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return WorkoutExerciseList.fromList(jsonDecode(response.body) ?? []).results;
      } else {
        throw GET_WORKOUT_EXERCISES_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  //#region CMS
  Future<String?> getCmsAssetByReference(final String reference) async {
    final url = Uri.parse(baseUrl + "CMS/asset/$reference");

    try {
      final response = await executeHttpGetWithoutAuth(url);
      if (response.statusCode == 200) {
        return CmsResponse.fromJson(
                StandardResponse.fromJson(jsonDecode(response.body)).payload ??
                    {})
            .body;
      } else {
        throw GET_PRIVACY_STATEMENT_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CMS>?> getCMSByType(final String cmsType) async {
    final url = Uri.parse(baseUrl + "CMS/bytype/$cmsType");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return CMSMultiResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_CMSBYTYPE_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region Notifications
  Future<List<Message>?> getAllUserNotifications() async {
    final url = Uri.parse(baseUrl + "notification");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return MessageResponse.fromList(
                ListResponse.fromJson(jsonDecode(response.body)).payload ?? [])
            .results;
      } else {
        throw GET_MESSAGES_FAILED;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markNotificationAsRead(final int? notificationId) async {
    final url = Uri.parse(baseUrl + "notification/read/$notificationId");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markNotificationAsDeleted(final int? notificationId) async {
    final url = Uri.parse(baseUrl + "notification/remove/$notificationId");

    try {
      final response = await executeHttpGet(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    } catch (e) {
      rethrow;
    }
  }
  //#endregion

  //#region Favourites
  Future<bool> addToFavourites(
      final String assetType, final int? assetId) async {
    final _favouriteType =
        assetType.toLowerCase() == "lesson" ? "L" : assetType;
    final url = Uri.parse(baseUrl + "Favorite");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.post(
      url,
      headers: {
        ...kWebServicesHeaders,
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, String>{
          'assetType': _favouriteType,
          'assetId': assetId.toString()
        },
      ),
    );

    if (response.statusCode == 200) {
      final standardResponse =
          StandardResponse.fromJson(jsonDecode(response.body));
      if (standardResponse.status?.toLowerCase() == "fail") {
        throw ADD_TO_FAVOURITE_FAILED;
      }
      return true;
    } else {
      throw ADD_TO_FAVOURITE_FAILED;
    }
  }

  Future<bool> removeFromFavourites(
      final String assetType, final int? assetId) async {
    final _favouriteType =
        assetType.toLowerCase() == "lesson" ? "L" : assetType;
    final url = Uri.parse(baseUrl + "Favorite/$_favouriteType/$assetId");
    final String? token = await AuthenticationController().getAccessToken();

    final response = await http.delete(url, headers: {
      ...kWebServicesHeaders,
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }
  //#endregion

  //#region App
  Future<bool> checkVersion(final String platform, final String version) async {
    final url = Uri.parse(
        baseUrl + "/app_services/min_supported_version/$platform/$version");
    final response = await executeHttpGetWithoutAuth(url);

    if (response.statusCode == 200) {
      final stdResponse = StandardResponse.fromJson(jsonDecode(response.body));
      if (stdResponse.status?.toLowerCase() == "ok") {
        return true;
      }
      return false;
    } else {
      //if the call fails, let the user continue anyway
      return true;
    }
  }
  //#endregion
}
