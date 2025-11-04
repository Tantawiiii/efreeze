import 'product_model.dart';

class ProductsListResponseModel {
  final String result;
  final List<ProductModel> data;
  final String message;
  final int status;

  ProductsListResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory ProductsListResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsListResponseModel(
      result: json['result'] as String,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  ProductModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
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

