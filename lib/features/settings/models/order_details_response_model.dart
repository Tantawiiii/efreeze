import 'order_details_model.dart';

class OrderDetailsResponseModel {
  final String result;
  final OrderDetailsModel data;
  final String message;
  final int status;

  OrderDetailsResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory OrderDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponseModel(
      result: json['result'] as String,
      data: OrderDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
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



