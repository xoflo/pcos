class KnowledgeBase {
  final int knowledgeBaseId;
  final String question;
  final String answer;

  KnowledgeBase({
    this.knowledgeBaseId,
    this.question,
    this.answer,
  });

  factory KnowledgeBase.fromJson(Map<String, dynamic> json) {
    return KnowledgeBase(
      knowledgeBaseId: json['knowledgeBaseId'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
