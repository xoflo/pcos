import 'package:thepcosprotocol_app/models/quiz_question.dart';

class Quiz {
  final int quizID;
  final int lessonID;
  final String title;
  final String description;
  final String endTitle;
  final String endMessage;
  List<QuizQuestion> questions;

  Quiz({
    this.quizID,
    this.lessonID,
    this.title,
    this.description,
    this.endTitle,
    this.endMessage,
    this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizID: json['quizID'],
      lessonID: json['lessonID'],
      title: json['title'],
      description: json['description'],
      endTitle: json['endTitle'],
      endMessage: json['endMessage'],
    );
  }
}
