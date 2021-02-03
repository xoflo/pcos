import 'dart:convert';

Question cmsFromJson(String str) {
  final jsonData = json.decode(str);
  return Question.fromMap(jsonData);
}

String cmsToJson(Question data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Question {
  int id;
  String reference;
  String question;
  String answer;
  String tags;

  Question({
    this.id,
    this.reference,
    this.question,
    this.answer,
    this.tags,
  });

  bool _isExpanded = false;

  bool get isExpanded {
    return this._isExpanded;
  }

  set isExpanded(final bool isExpanded) {
    this._isExpanded = isExpanded;
  }

  factory Question.fromMap(Map<String, dynamic> json) => new Question(
        reference: json["reference"],
        question: json["question"],
        answer: json["answer"],
        tags: json["tags"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "reference": reference,
        "question": question,
        "answer": answer,
        "tags": tags,
      };
}
