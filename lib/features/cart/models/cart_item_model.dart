import '../../home/models/product_model.dart';

class CartItemModel {
  final int id;
  final int userId;
  final int cardId;
  final int quantity;
  final String createdAt;
  final String updatedAt;
  final ProductModel card;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.card,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      cardId: json['card_id'] as int,
      quantity: json['quantity'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      card: ProductModel.fromJson(json['card'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'card_id': cardId,
      'quantity': quantity,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'card': card.toJson(),
    };
  }
}

