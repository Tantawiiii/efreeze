import '../../home/models/product_model.dart';

class OrderCardItemModel {
  final int id;
  final int cardId;
  final int qty;
  final String? color;
  final ProductModel? card;

  OrderCardItemModel({
    required this.id,
    required this.cardId,
    required this.qty,
    this.color,
    this.card,
  });

  factory OrderCardItemModel.fromJson(Map<String, dynamic> json) {
    final cardJson = json['card'];
    return OrderCardItemModel(
      id: json['id'] as int,
      cardId: json['card_id'] as int,
      qty: json['qty'] as int? ?? 0,
      color: json['color'] as String?,
      card: cardJson is Map<String, dynamic>
          ? ProductModel.fromJson(cardJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'qty': qty,
      'color': color,
      'card': card?.toJson(),
    };
  }
}
