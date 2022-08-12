import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class MemberProvider extends ChangeNotifier {
  Member member = Member();
  Member memberOriginal = Member();
  LoadingStatus status = LoadingStatus.empty;

  String _why = "";
  String get why => _why;

  int? get id {
    return this.member.id;
  }

  String get firstName {
    return this.member.firstName ?? "";
  }

  String get lastName {
    return this.member.lastName ?? "";
  }

  String get alias {
    return this.member.alias ?? "";
  }

  String get email {
    return this.member.email ?? "";
  }

  set firstName(String firstName) {
    this.member.firstName = firstName;
  }

  set lastName(String lastName) {
    this.member.lastName = lastName;
  }

  set email(String email) {
    this.member.email = email;
  }

  set alias(String alias) {
    this.member.alias = alias;
  }

  Future<bool> setWhy(String why) async {
    status = LoadingStatus.loading;
    notifyListeners();

    final bool didSetWhy =
        await WebServices().setMemberWhy(member.id.toString(), why);

    _why = why;

    status = LoadingStatus.success;
    notifyListeners();

    return didSetWhy;
  }

  Future<void> populateMember() async {
    status = LoadingStatus.loading;
    try {
      final Member? memberDetails = await WebServices().getMemberDetails();

      if (memberDetails != null) {
        this.member = memberDetails;
        this.memberOriginal.firstName = memberDetails.firstName;
        this.memberOriginal.lastName = memberDetails.lastName;
        this.memberOriginal.email = memberDetails.email;
        this.memberOriginal.alias = memberDetails.alias;

        final String whatsYourWhy = await PreferencesController()
            .getString(SharedPreferencesKeys.WHATS_YOUR_WHY);
        _why = whatsYourWhy;
        
        status = LoadingStatus.success;
      } else {
        status = LoadingStatus.empty;
      }
    } catch (ex) {
      status = LoadingStatus.empty;
    }
    notifyListeners();
  }

  Future<bool> saveMemberDetails() async {
    status = LoadingStatus.loading;
    String requestBody = "{";
    bool nameChanged = false;

    if (memberOriginal.firstName != member.firstName) {
      requestBody += "'firstName': '${member.firstName}'";
      nameChanged = true;
    }

    if (memberOriginal.lastName != member.lastName) {
      if (nameChanged) {
        requestBody += ",";
      }
      requestBody += "'lastName': '${member.lastName}'";
      nameChanged = true;
    }

    if (memberOriginal.email != member.email) {
      if (nameChanged) {
        requestBody += ",";
      }
      requestBody += "'email': '${member.email}'";
    }
    if (memberOriginal.alias != member.alias) {
      if (nameChanged) {
        requestBody += ",";
      }
      requestBody += "'alias': '${member.alias}'";
    }

    requestBody += "}";

    final bool saved = await WebServices().updateMemberDetails(requestBody);

    status = LoadingStatus.success;
    notifyListeners();
    return saved;
  }
}
