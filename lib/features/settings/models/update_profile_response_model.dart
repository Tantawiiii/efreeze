import '../../auth/models/user_model.dart';

class UpdateProfileResponseModel {
  final String result;
  final UserModel data;
  final String message;
  final int status;

  UpdateProfileResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final result = json['result']?.toString() ?? '';
    final statusValue = json['status'];
    final status = statusValue is int
        ? statusValue
        : int.tryParse(statusValue?.toString() ?? '') ?? 0;

    String message = '';
    Map<String, dynamic>? messageMap;

    final rawMessage = json['message'];
    if (rawMessage is Map<String, dynamic>) {
      messageMap = rawMessage;
      message = rawMessage['message']?.toString() ?? '';
    } else if (rawMessage != null) {
      message = rawMessage.toString();
    }

    Map<String, dynamic>? userMap;
    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      userMap = rawData;
    } else if (messageMap != null && messageMap['data'] is Map<String, dynamic>) {
      userMap = messageMap['data'] as Map<String, dynamic>;
    }

    if (userMap == null) {
      throw const FormatException('Missing user data in update profile response.');
    }

    return UpdateProfileResponseModel(
      result: result,
      data: UserModel.fromJson(userMap),
      message: message.isNotEmpty ? message : 'Profile updated successfully',
      status: status,
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





