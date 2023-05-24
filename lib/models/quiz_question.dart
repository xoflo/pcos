import 'package:thepcosprotocol_app/models/quiz_answer.dart';

import '../utils/comparable_utils.dart';

class QuizQuestion with Compare<QuizQuestion> {
  final int quizQuestionID;
  final int quizID;
  final String questionType;
  final String questionText;
  final String response;
  final int orderIndex;
  List<QuizAnswer>? answers;
  bool? isMultiChoice;

  QuizQuestion({
    required this.quizQuestionID,
    required this.quizID,
    required this.questionType,
    required this.questionText,
    required this.response,
    required this.orderIndex,
    this.answers,
    this.isMultiChoice,
  });

  @override
  int compareTo(QuizQuestion other) {
    var comparisonResult = orderIndex.compareTo(other.orderIndex);
    if (comparisonResult != 0) {
      return comparisonResult;
    }

    return quizQuestionID.compareTo(other.quizQuestionID);
  }

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
