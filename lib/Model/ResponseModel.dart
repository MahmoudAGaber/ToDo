

class ResponseModel{
  dynamic data;
  bool status;
  String message;
  int code;

  ResponseModel({this.data, required this.status, required this.message, required this.code});

  factory ResponseModel.Json(Map json){
    return ResponseModel(
        data: json['data'],
        status: json['status'],
        message: json['message'],
        code: json['code']

    );
  }

}