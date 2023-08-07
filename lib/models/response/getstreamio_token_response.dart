class GetStreamIOResponse {
  final String? status;
  final String? message;
  final String? info;
  final String? payload;

  GetStreamIOResponse({this.status, this.message, this.info, this.payload});

  factory GetStreamIOResponse.fromJson(Map<String, dynamic> json) {
    return GetStreamIOResponse(
        status: json['status'],
        message: json['message'],
        info: json['info'],
        payload: json['payload']);
  }
}
