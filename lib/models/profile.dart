import 'package:flutter/foundation.dart';

class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String alias;
  final String email;
  final String countryID;
  final bool isAdmin;
  final DateTime dateCreatedUTC;

  Profile(
      {this.id,
      this.firstName,
      this.lastName,
      this.alias,
      this.email,
      this.countryID,
      this.isAdmin,
      this.dateCreatedUTC});

  factory Profile.fromJson(Map<String, dynamic> json) {
    debugPrint("******PROFILE JSON = $json");
    return Profile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        alias: json['alias'],
        email: json['email'],
        countryID: json['countryID'],
        isAdmin: json['isAdmin'],
        dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']));
  }
}
