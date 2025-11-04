import 'cart_item_model.dart';

class CartResponseModel {
  final String result;
  final List<CartItemModel> data;
  final String message;
  final int status;

  CartResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      result: json['result'] as String,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  CartItemModel.fromJson(item as Map<String, dynamic>))
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

