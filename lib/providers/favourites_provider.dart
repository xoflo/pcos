import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class FavouritesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  FavouritesProvider({@required this.dbProvider}) {
    if (dbProvider != null) getDataFromDatabase(dbProvider);
  }

  final String tableName = "Favourites";
  List<Message> _items = [];
  LoadingStatus status = LoadingStatus.empty;

  List<Message> get items => [..._items];

  Future<List<Message>> getDataFromDatabase(
    final dbProvider,
  ) async {
    List<Message> messages = List<Message>();

    final Message message1 = Message(
        title: "This is a new message.",
        messageText: "Hi, we sent you a message, hope you like it.",
        isRead: false,
        action: "",
        dateCreatedUTC: DateTime.now().toUtc());
    final Message message2 = Message(
        title: "This is another message.",
        messageText: "This is the second message.",
        isRead: false,
        action: "",
        dateCreatedUTC: DateTime.now().toUtc());
    final Message message3 = Message(
        title: "This is the third message.",
        messageText: "Hi, this is another message.",
        isRead: false,
        action: "",
        dateCreatedUTC: DateTime.now().toUtc());
    messages.add(message1);
    messages.add(message2);
    return messages;
  }
}
