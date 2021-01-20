import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';

class MemberViewModel extends ChangeNotifier {
  Member member;
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

  set alias(String alias) {
    this.member.alias = alias;
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
        status = LoadingStatus.success;
      } else {
        status = LoadingStatus.empty;
      }
    } catch (ex) {
      status = LoadingStatus.empty;
    }
    notifyListeners();
  }
}
