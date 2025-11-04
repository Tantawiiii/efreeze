import '../../home/models/product_model.dart';

class FavoriteItemModel {
  final int id;
  final Map<String, dynamic> user;
  final ProductModel card;
  final String createdAt;
  final String updatedAt;

  FavoriteItemModel({
    required this.id,
    required this.user,
    required this.card,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] as int,
      user: json['user'] as Map<String, dynamic>,
      card: ProductModel.fromJson(json['card'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'card': card.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

