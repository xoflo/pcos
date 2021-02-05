class Message {
  final String title;
  final String text;
  final bool isRead;

  Message({this.title, this.text, this.isRead});

  factory Message.fromValues(
      final String title, final String text, final bool isRead) {
    return Message(
      title: title,
      text: text,
      isRead: isRead,
    );
  }
}
