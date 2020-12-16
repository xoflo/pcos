class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String alias;
  final String countryID;
  final bool isAdmin;
  final dateCreatedUTC;

  Profile(
      {this.id,
      this.firstName,
      this.lastName,
      this.alias,
      this.countryID,
      this.isAdmin,
      this.dateCreatedUTC});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        alias: json['alias'],
        countryID: json['countryID'],
        isAdmin: json['isAdmin'],
        dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']));
  }
}
