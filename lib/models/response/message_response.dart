import 'package:thepcosprotocol_app/models/message.dart';

class MessageResponse {
  List<Message> results;

  MessageResponse({this.results});

  factory MessageResponse.fromList(List<dynamic> json) {
    List<Message> cmsItems = List<Message>();
    if (json.length > 0) {
      json.forEach((item) {
        cmsItems.add(Message.fromJson(item));
      });
    }
    return MessageResponse(results: cmsItems);
  }
}

/*
{
  "status": "OK",
  "message": "",
  "info": "",
  "payload": [
    {
      "notificationId": 2,
      "message": "Hi Andy, here is another message, do we need a title too?",
      "isRead": false,
      "dateReadUTC": "1900-01-01T00:00:00",
      "dateCreatedUTC": "2021-02-11T02:29:00"
    },
    {
      "notificationId": 1,
      "message": "Hi Andy, this is a notification message.",
      "isRead": false,
      "dateReadUTC": "1900-01-01T00:00:00",
      "dateCreatedUTC": "2021-02-11T02:27:59.123"
    }
  ]
}
*/
