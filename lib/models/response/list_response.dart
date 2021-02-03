class ListResponse {
  final String status;
  final String message;
  final String info;
  final List<dynamic> payload;

  ListResponse({this.status, this.message, this.info, this.payload});

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    return ListResponse(
      status: json['status'],
      message: json['message'],
      info: json['info'],
      payload: json['payload'],
    );
  }
}
