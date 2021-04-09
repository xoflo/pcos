class LessonCompleteResponse {
  final String status;
  final String message;
  final String info;
  final String payload;

  LessonCompleteResponse({this.status, this.message, this.info, this.payload});

  factory LessonCompleteResponse.fromJson(Map<String, dynamic> json) {
    return LessonCompleteResponse(
        status: json['status'],
        message: json['message'],
        info: json['info'],
        payload: json['payload']);
  }
}
