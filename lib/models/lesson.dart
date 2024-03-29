class Lesson extends Comparable<Lesson> {
  final int lessonID;
  final int moduleID;
  final String imageUrl;
  final String title;
  final String introduction;
  final int hoursToNextLesson;
  final int hoursUntilAvailable;
  final int minsToComplete;
  final int orderIndex;
  final bool isComplete;
  final bool isToolkit;
  final DateTime dateCreatedUTC;
  bool isFavorite;

  Lesson({
    required this.lessonID,
    required this.moduleID,
    required this.imageUrl,
    required this.title,
    required this.hoursToNextLesson,
    required this.hoursUntilAvailable,
    required this.minsToComplete,
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
      imageUrl: json['imageUrl'],
      title: json['title'],
      hoursToNextLesson: json['hoursToNextLesson'],
      hoursUntilAvailable: json['hoursUntilAvailable'] ?? 0,
      minsToComplete: json['minsToComplete'] ?? 0,
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

  @override
  int compareTo(Lesson other) {
    var comparisonResult = orderIndex.compareTo(other.orderIndex);
    if (comparisonResult != 0) {
      return comparisonResult;
    }

    return lessonID.compareTo(other.lessonID);
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
