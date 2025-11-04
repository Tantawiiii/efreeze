import 'offer_model.dart';

class OffersResponseModel {
  final String result;
  final List<OfferModel> data;
  final String message;
  final int status;

  OffersResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory OffersResponseModel.fromJson(Map<String, dynamic> json) {
    return OffersResponseModel(
      result: json['result'] as String,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  OfferModel.fromJson(item as Map<String, dynamic>))
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

