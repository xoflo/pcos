import 'package:thepcosprotocol_app/models/cms.dart';

class CMSMultiResponse {
  List<CMS> results;

  CMSMultiResponse({this.results});

  factory CMSMultiResponse.fromList(List<dynamic> json) {
    List<CMS> cmsItems = [];
    if (json.length > 0) {
      json.forEach((item) {
        cmsItems.add(CMS.fromJson(item));
      });
    }
    return CMSMultiResponse(results: cmsItems);
  }
}

/*
{
  "status": "OK",
  "message": "",
  "info": "",
  "payload": [
    {
      "cmsId": 8,
      "reference": "FAQ1",
      "groupId": "1",
      "body": "Test FAQ",
      "tags": "",
      "orderIndex": 0,
      "isAuthenticated": true,
      "lastUpdatedUTC": "2021-01-27T21:10:47.84",
      "dateCreatedUTC": "2021-01-27T21:10:47.84"
    },
    {
      "cmsId": 9,
      "reference": "FAQ2",
      "groupId": "1",
      "body": "",
      "tags": "This is the answer to FAQ 1",
      "orderIndex": 1,
      "isAuthenticated": true,
      "lastUpdatedUTC": "2021-01-27T19:32:55.55",
      "dateCreatedUTC": "2021-01-27T19:32:55.55"
    }
  ]
}
 */
