class CMS {
  final int? cmsId;
  final String? reference;
  final String? groupId;
  final String? body;
  final String? tags;
  final int? orderIndex;
  final bool? isFavorite;

  CMS({
    this.cmsId,
    this.reference,
    this.groupId,
    this.body,
    this.tags,
    this.orderIndex,
    this.isFavorite,
  });

  factory CMS.fromJson(Map<String, dynamic> json) {
    return CMS(
      cmsId: json['cmsId'],
      reference: json['reference'],
      groupId: json['groupId'],
      body: json['body'],
      tags: json['tags'],
      orderIndex: json['orderIndex'],
      isFavorite: json['isFavorite'],
    );
  }
}

/*
{
  "cmsId": 7,
  "reference": "GettingStarted",
  "groupId": "",
  "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  "tags": "",
  "orderIndex": 0,
  "isAuthenticated": false,
  "isFavorite": false,
  "lastUpdatedUTC": "2021-01-18T22:35:13.183",
  "dateCreatedUTC": "2021-01-18T22:35:13.183"
}
*/
