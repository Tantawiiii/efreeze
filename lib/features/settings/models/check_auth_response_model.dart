import '../../auth/models/user_model.dart';

class CheckAuthResponseModel {
  final String result;
  final UserModel data;
  final String message;
  final int status;

  CheckAuthResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory CheckAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckAuthResponseModel(
      result: json['result'] as String,
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.toJson(),
      'message': message,
      'status': status,
    };
  }
}







