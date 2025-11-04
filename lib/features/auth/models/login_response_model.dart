import 'user_model.dart';
import 'dart:convert';

class LoginResponseModel {
  final String result;
  final UserModel data;
  final String message;
  final int status;
  final String token;

  LoginResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      result: json['result'] as String,
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as int,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.toJson(),
      'message': message,
      'status': status,
      'token': token,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory LoginResponseModel.fromJsonString(String jsonString) {
    return LoginResponseModel.fromJson(jsonDecode(jsonString));
  }
}

