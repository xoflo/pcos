import '../utils/comparable_utils.dart';

class Module with Compare<Module> {
  final int moduleID;
  final String title;
  final bool isComplete;
  final int orderIndex;
  final String? iconUrl;

  final DateTime? dateCreatedUTC;

  Module({
    required this.moduleID,
    required this.title,
    required this.isComplete,
    required this.orderIndex,
    this.iconUrl,
    this.dateCreatedUTC,
  });

  @override
  int compareTo(Module other) {
    var comparisonResult = orderIndex.compareTo(other.orderIndex);
    if (comparisonResult != 0) {
      return comparisonResult;
    }

    return moduleID.compareTo(other.moduleID);
  }

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
