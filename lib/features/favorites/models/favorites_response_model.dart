import 'favorite_item_model.dart';

class FavoritesResponseModel {
  final String result;
  final List<FavoriteItemModel> data;
  final String message;
  final int status;

  FavoritesResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory FavoritesResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoritesResponseModel(
      result: json['result'] as String,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  FavoriteItemModel.fromJson(item as Map<String, dynamic>))
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

