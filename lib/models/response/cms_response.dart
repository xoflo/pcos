class CmsResponse {
  String body;

  CmsResponse({this.body});

  factory CmsResponse.fromJson(Map<String, dynamic> json) {
    String cmsBody = "";
    if (json['body'] != null) {
      cmsBody = json['body'];
    }
    return CmsResponse(body: cmsBody);
  }
}
