import 'package:thepcosprotocol_app/models/quiz_answer.dart';

class QuizQuestion {
  final int? quizQuestionID;
  final int? quizID;
  final String? questionType;
  final String? questionText;
  final String? response;
  final int? orderIndex;
  List<QuizAnswer>? answers;
  bool? isMultiChoice;

  QuizQuestion({
    this.quizQuestionID,
    this.quizID,
    this.questionType,
    this.questionText,
    this.response,
    this.orderIndex,
    this.answers,
    this.isMultiChoice,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      quizQuestionID: json['quizQuestionID'],
      quizID: json['quizID'],
      questionType: json['questionType'],
      questionText: json['questionText'],
      response: json['response'],
      orderIndex: json['orderIndex'],
    );
  }
}

/*
"quizQuestionID INTEGER PRIMARY KEY,"
"quizID INTEGER,"
"questionType TEXT,"
"questionText TEXT,"
"response TEXT,"
"orderIndex INTEGER"
*/
