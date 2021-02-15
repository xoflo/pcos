class Member {
  final int id;
  final String preRegistrationCode;
  String firstName;
  String lastName;
  String alias;
  String email;
  final String twitter;
  final String facebook;
  final String countryID;
  final String contactPhone;
  final String adminNotes;
  final bool isEmailVerified;
  final bool isEnabled;
  final DateTime dateCreatedUTC;

  Member(
      {this.id,
      this.preRegistrationCode,
      this.firstName,
      this.lastName,
      this.alias,
      this.email,
      this.twitter,
      this.facebook,
      this.countryID,
      this.contactPhone,
      this.adminNotes,
      this.isEmailVerified,
      this.isEnabled,
      this.dateCreatedUTC});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['id'],
        preRegistrationCode: json['preRegistrationCode'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        alias: json['alias'],
        email: json['email'],
        twitter: json['twitter'],
        facebook: json['facebook'],
        countryID: json['countryID'],
        contactPhone: json['contactPhone'],
        adminNotes: json['adminNotes'],
        isEmailVerified: json['isEmailVerified'],
        isEnabled: json['isEnabled'],
        dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']));
  }
}
/*
"id":2,
"preRegistrationCode":"",
"firstName":"Andy",
"lastName":"Frost",
"alias":"andyfrost50",
"email":"andyfrost50@hotmail.com",
"twitter":"",
"facebook":"",
"countryID":"",
"contactPhone":"",
"adminNotes":"",
"isEmailVerified":true,
"isEnabled":true,
"dateCreatedUTC":"2020-12-13T23:18:51.08"
*/