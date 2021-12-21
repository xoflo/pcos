class QuizAnswer {
  final int quizAnswerID;
  final int quizQuestionID;
  final String answerText;
  final bool isCorrect;
  final String response;
  final int orderIndex;

  QuizAnswer({
    this.quizAnswerID,
    this.quizQuestionID,
    this.answerText,
    this.isCorrect,
    this.response,
    this.orderIndex,
  });

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
