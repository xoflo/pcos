class Message {
  final String title;
  final String messageText;
  final bool isRead;
  final String action;
  final DateTime dateCreatedUTC;

  Message(
      {this.title,
      this.messageText,
      this.isRead,
      this.action,
      this.dateCreatedUTC});

  factory Message.fromValues(
    final String title,
    final String messageText,
    final bool isRead,
    final String action,
    final DateTime dateCreatedUTC,
  ) {
    return Message(
      title: title,
      messageText: messageText,
      isRead: isRead,
      action: action,
      dateCreatedUTC: dateCreatedUTC,
    );
  }
}
