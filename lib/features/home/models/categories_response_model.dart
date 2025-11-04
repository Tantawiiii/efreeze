import 'category_model.dart';

class CategoriesResponseModel {
  final String result;
  final List<CategoryModel> data;
  final String message;
  final int status;

  CategoriesResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      result: json['result'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
      'status': status,
    };
  }
}

