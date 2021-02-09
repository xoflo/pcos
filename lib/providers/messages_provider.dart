import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/providers/provider_helper.dart';
import 'package:thepcosprotocol_app/models/message.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';

class MessagesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  MessagesProvider({@required this.dbProvider}) {
    if (dbProvider != null) getDataFromDatabase(dbProvider);
  }

  final String tableName = "Message";
  List<Message> _items = [];
  LoadingStatus status = LoadingStatus.empty;

  List<Message> get items => [..._items];

  Future<void> getDataFromDatabase(
    final dbProvider,
  ) async {
    status = LoadingStatus.loading;
    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    List<Message> messages = List<Message>();

    final Message message1 = Message(
        title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        messageText:
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        isRead: false,
        action: "",
        dateCreatedUTC: DateTime.now().toUtc());
    final Message message2 = Message(
        title: "Sed rhoncus lectus a tincidunt mollis",
        messageText:
            "Duis nisl libero, fringilla et laoreet id, egestas at magna. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque enim lacus, imperdiet quis sodales id, sagittis quis felis. Ut ultricies sed magna vitae pretium. Vestibulum at rutrum est. In fringilla turpis ac odio sollicitudin, vel volutpat eros convallis.",
        isRead: false,
        action: "",
        dateCreatedUTC: DateTime.now().toUtc());
    final Message message3 = Message(
        title: "Nam ornare consequat mi at vulputate",
        messageText:
            "Pellentesque aliquet odio sit amet pharetra fringilla. In pulvinar ac orci vitae malesuada. Nam hendrerit mattis diam eu faucibus. Aenean nec fermentum nunc. Sed et purus ut ex venenatis finibus ut eu nisi. Nulla convallis ipsum quis maximus lacinia. Integer enim nunc, dapibus nec pulvinar et, tincidunt eu neque.",
        isRead: true,
        action: "",
        dateCreatedUTC: DateTime.now().toUtc());
    messages.add(message1);
    messages.add(message2);
    messages.add(message3);
    messages.add(message1);
    messages.add(message2);
    messages.add(message3);
    messages.add(message1);
    messages.add(message2);
    messages.add(message3);
    _items = messages;

    status = _items.isEmpty ? LoadingStatus.empty : LoadingStatus.success;
    notifyListeners();
  }
}
