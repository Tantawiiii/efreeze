class AddFavoriteResponseModel {
  final String result;
  final dynamic data;
  final String message;
  final int status;

  AddFavoriteResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory AddFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return AddFavoriteResponseModel(
      result: json['result'] as String,
      data: json['data'],
      message: json['message'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data,
      'message': message,
      'status': status,
    };
  }
}

