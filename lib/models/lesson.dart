class Lesson {
  final int lessonID;
  final int moduleID;
  final String title;
  final String introduction;
  final int orderIndex;
  final bool isFavorite;
  final bool isComplete;
  final DateTime dateCreatedUTC;

  Lesson({
    this.lessonID,
    this.moduleID,
    this.title,
    this.introduction,
    this.orderIndex,
    this.isFavorite,
    this.isComplete,
    this.dateCreatedUTC,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonID: json['lessonID'],
      moduleID: json['moduleID'],
      title: json['title'],
      introduction: json['introduction'],
      orderIndex: json['orderIndex'],
      isFavorite:
          json['isFavorite'] == 1 || json['isFavorite'] == true ? true : false,
      isComplete:
          json['isComplete'] == 1 || json['isComplete'] == true ? true : false,
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
  "dateCreatedUTC": "2021-03-18T23:00:00"
},
*/
