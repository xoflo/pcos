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
  String id;
  String reference;
  String questionType;
  String question;
  String answer;
  String tags;

  Question({
    this.id,
    this.reference,
    this.questionType,
    this.question,
    this.answer,
    this.tags,
  });

  factory Question.fromMap(Map<String, dynamic> json) => new Question(
        reference: json["reference"],
        questionType: json["assetyype"],
        question: json["question"],
        answer: json["answer"],
        tags: json["tags"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "reference": reference,
        "assetType": questionType,
        "question": question,
        "answer": answer,
        "tags": tags,
      };
}
