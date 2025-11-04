import 'category_details_model.dart';

class CategoryDetailsResponseModel {
  final String result;
  final CategoryDetailsModel data;
  final String message;
  final int status;

  CategoryDetailsResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory CategoryDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsResponseModel(
      result: json['result'] as String,
      data: CategoryDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
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
