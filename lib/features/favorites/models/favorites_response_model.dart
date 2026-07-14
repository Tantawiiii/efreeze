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
    final items = (json['data'] as List<dynamic>?)
            ?.map(
              (item) => FavoriteItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        <FavoriteItemModel>[];

    final seen = <int>{};
    final deduped = <FavoriteItemModel>[];
    for (final item in items.reversed) {
      if (seen.add(item.card.id)) {
        deduped.add(item);
      }
    }

    return FavoritesResponseModel(
      result: json['result'] as String? ?? '',
      data: deduped.reversed.toList(),
      message: json['message'] as String? ?? '',
      status: json['status'] as int? ?? 0,
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

