class MemberTypeTagList {
  List<MemberTypeTag>? results;

  MemberTypeTagList({this.results});

  factory MemberTypeTagList.fromList(List<dynamic> json) {
    List<MemberTypeTag> lessonList = [];
    if (json.length > 0) {
      json.forEach((item) {
        lessonList.add(MemberTypeTag.fromJson(item));
      });
    }
    return MemberTypeTagList(results: lessonList);
  }
}

class MemberTypeTag {
  final int? typeTagID;
  final String? tag;
  final String? summary;
  final String? description;
  final int? orderIndex;
  final DateTime? dateCreatedUTC;

  MemberTypeTag({
    this.typeTagID,
    this.tag,
    this.summary,
    this.description,
    this.orderIndex,
    this.dateCreatedUTC,
  });

  factory MemberTypeTag.fromJson(Map<String, dynamic> json) {
    String nextLessonDateString = json['dateCreatedUTC'];
    if (!nextLessonDateString.endsWith("Z")) {
      nextLessonDateString = "${nextLessonDateString}Z";
    }

    return MemberTypeTag(
      typeTagID: json['typeTagID'],
      tag: json['tag'],
      summary: json['summary'],
      description: json['description'],
      orderIndex: json['orderIndex'],
      dateCreatedUTC: DateTime.parse(nextLessonDateString),
    );
  }
}
