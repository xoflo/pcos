import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';

class MemberViewModel extends ChangeNotifier {
  Member member;
  Member memberOriginal = Member();
  LoadingStatus status = LoadingStatus.empty;

  MemberViewModel();

  int get id {
    return this.member.id;
  }

  String get firstName {
    return this.member.firstName;
  }

  String get lastName {
    return this.member.lastName;
  }

  String get alias {
    return this.member.alias;
  }

  String get email {
    return this.member.email;
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

  Future<void> populateMember() async {
    status = LoadingStatus.loading;
    try {
      final Member memberDetails = await WebServices().getMemberDetails();

      if (memberDetails != null) {
        this.member = memberDetails;
        this.memberOriginal.firstName = memberDetails.firstName;
        this.memberOriginal.lastName = memberDetails.lastName;
        this.memberOriginal.email = memberDetails.email;

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

    requestBody += "}";

    final bool saved = await WebServices().updateMemberDetails(requestBody);

    status = LoadingStatus.success;
    notifyListeners();
    return saved;
  }
}
