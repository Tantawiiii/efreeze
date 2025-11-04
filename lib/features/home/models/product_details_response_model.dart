import 'product_model.dart';

class ProductDetailsResponseModel {
  final String result;
  final ProductModel data;
  final String message;
  final int status;

  ProductDetailsResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModel(
      result: json['result'] as String,
      data: ProductModel.fromJson(json['data'] as Map<String, dynamic>),
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

