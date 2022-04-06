class LessonWiki {
  int questionId;
  int lessonId;
  int moduleId;
  String reference;
  String question;
  String answer;
  String tags;
  bool isFavorite;
  bool isLongAnswer;

  LessonWiki({
    this.questionId,
    this.lessonId,
    this.moduleId,
    this.reference,
    this.question,
    this.answer,
    this.tags,
    this.isFavorite,
    this.isLongAnswer,
  });

  bool _isExpanded = false;

  bool get isExpanded {
    return this._isExpanded;
  }

  set isExpanded(final bool isExpanded) {
    this._isExpanded = isExpanded;
  }

  factory LessonWiki.fromJson(Map<String, dynamic> json) {
    final String answerHtml = json["answer"];
    final bool isLongAnswer =
        (answerHtml.contains("<img ") || answerHtml.length > 300)
            ? true
            : false;

    return LessonWiki(
      questionId: json['id'],
      lessonId: json['lessonID'],
      moduleId: json['moduleID'],
      reference: json["reference"],
      question: json["question"],
      answer: json["answer"],
      tags: json["tags"],
      isFavorite:
          json['isFavorite'] == 1 || json['isFavorite'] == true ? true : false,
      isLongAnswer: isLongAnswer,
    );
  }
}
