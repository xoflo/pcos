import '../utils/comparable_utils.dart';

class QuizAnswer with Compare<QuizAnswer> {
  final int quizAnswerID;
  final int quizQuestionID;
  final String answerText;
  final bool isCorrect;
  final String response;
  final int orderIndex;

  QuizAnswer({
    required this.quizAnswerID,
    required this.quizQuestionID,
    required this.answerText,
    required this.isCorrect,
    required this.response,
    required this.orderIndex,
  });

  @override
  int compareTo(QuizAnswer other) {
    var comparisonResult = orderIndex.compareTo(other.orderIndex);
    if (comparisonResult != 0) {
      return comparisonResult;
    }

    return quizAnswerID.compareTo(other.quizAnswerID);
  }

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      quizAnswerID: json['quizAnswerID'],
      quizQuestionID: json['quizQuestionID'],
      answerText: json['answerText'],
      isCorrect: json['isCorrect'] == 1 ? true : false,
      response: json['response'],
      orderIndex: json['orderIndex'],
    );
  }
}

/*
"quizAnswerID INTEGER PRIMARY KEY,"
"quizQuestionID INTEGER,"
"answerText TEXT,"
"isCorrect INTEGER,"
"response TEXT,"
"orderIndex INTEGER"
*/
