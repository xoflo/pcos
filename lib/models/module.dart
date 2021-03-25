class Module {
  final int moduleID;
  final String title;
  final DateTime dateCreatedUTC;
  final bool isComplete;

  Module({
    this.moduleID,
    this.title,
    this.dateCreatedUTC,
    this.isComplete,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleID: json['moduleID'],
      title: json['title'],
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
      isComplete: json['isComplete'],
    );
  }
}

/*
moduleID: 1,
title: This is a test module,
dateCreatedUTC: 2021-03-18T22:25:00
*/
