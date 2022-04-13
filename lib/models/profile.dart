class Profile {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? alias;
  final String? email;
  final String? pcosType;
  final String? whatsMyWhy;
  final String? countryID;
  final bool? isAdmin;
  final DateTime? dateCreatedUTC;

  Profile(
      {this.id,
      this.firstName,
      this.lastName,
      this.alias,
      this.email,
      this.pcosType,
      this.whatsMyWhy,
      this.countryID,
      this.isAdmin,
      this.dateCreatedUTC});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        alias: json['alias'],
        email: json['email'],
        pcosType: json['pcosType'],
        whatsMyWhy: json['whatsMyWhy'],
        countryID: json['countryID'],
        isAdmin: json['isAdmin'],
        dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']));
  }
}
