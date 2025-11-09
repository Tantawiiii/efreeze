import '../../home/models/product_model.dart';

class OrderCardItemModel {
  final int id;
  final int cardId;
  final int qty;
  final ProductModel card;

  OrderCardItemModel({
    required this.id,
    required this.cardId,
    required this.qty,
    required this.card,
  });

  factory OrderCardItemModel.fromJson(Map<String, dynamic> json) {
    return OrderCardItemModel(
      id: json['id'] as int,
      cardId: json['card_id'] as int,
      qty: json['qty'] as int,
      card: ProductModel.fromJson(json['card'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'qty': qty,
      'card': card.toJson(),
    };
  }
}



