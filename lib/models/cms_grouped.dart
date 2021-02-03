class CMSGrouped {
  final String question;
  final String answer;

  CMSGrouped({
    this.question,
    this.answer,
  });

  factory CMSGrouped.fromStrings(final String question, final String answer) {
    return CMSGrouped(
      question: question,
      answer: answer,
    );
  }
}
