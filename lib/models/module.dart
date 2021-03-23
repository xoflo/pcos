class Module {
  final int moduleID;
  final String title;
  final DateTime dateCreatedUTC;

  Module({
    this.moduleID,
    this.title,
    this.dateCreatedUTC,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleID: json['moduleID'],
      title: "This is the title",
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }
}

/*
moduleID: 1,
title: This is a test module,
dateCreatedUTC: 2021-03-18T22:25:00
*/
