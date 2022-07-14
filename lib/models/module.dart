class Module {
  final int? moduleID;
  final String? iconUrl;
  final String? title;
  final bool? isComplete;
  final int? orderIndex;
  final DateTime? dateCreatedUTC;

  Module({
    this.moduleID,
    this.iconUrl,
    this.title,
    this.isComplete,
    this.orderIndex,
    this.dateCreatedUTC,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleID: json['moduleID'],
      iconUrl: json['iconUrl'],
      title: json['title'],
      isComplete:
          json['isComplete'] == 1 || json['isComplete'] == true ? true : false,
      orderIndex: json['orderIndex'],
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }
}

/*
moduleID: 1,
title: This is a test module,
dateCreatedUTC: 2021-03-18T22:25:00
*/
