class Lesson {
  final int lessonID;
  final int moduleID;
  final String title;
  final String introduction;
  final int orderIndex;
  final bool isComplete;
  final bool isToolkit;
  final DateTime dateCreatedUTC;
  bool isFavorite;

  Lesson({
    required this.lessonID,
    required this.moduleID,
    required this.title,
    required this.introduction,
    required this.orderIndex,
    required this.isFavorite,
    required this.isComplete,
    required this.isToolkit,
    required this.dateCreatedUTC,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonID: json['lessonID'],
      moduleID: json['moduleID'] ?? 0,
      title: json['title'],
      introduction: json['introduction'],
      orderIndex: json['orderIndex'],
      isFavorite:
          json['isFavorite'] == 1 || json['isFavorite'] == true ? true : false,
      isComplete:
          json['isComplete'] == 1 || json['isComplete'] == true ? true : false,
      isToolkit:
          json['isToolkit'] == 1 || json['isToolkit'] == true ? true : false,
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
    );
  }
}

/*
"lesson":
{
  "lessonID": 1,
  "moduleID": 1,
  "title": "This is the first lesson",
  "introduction": "Hi, welcome to the first lesson, this is the first lesson.",
  "orderIndex": 0,
  "isFavorite": false,
  "isComplete": true,
  "isToolkit": true,
  "dateCreatedUTC": "2021-03-18T23:00:00"
},
*/
