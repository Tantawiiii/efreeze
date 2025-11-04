import 'order_card_model.dart';

class CreateOrderRequestModel {
  final String email;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String zipCode;
  final String paymentMethod;
  final String? promoCode;
  final List<OrderCardModel> cards;

  CreateOrderRequestModel({
    required this.email,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.paymentMethod,
    this.promoCode,
    required this.cards,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'address_line': addressLine,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'payment_method': paymentMethod,
      if (promoCode != null && promoCode!.isNotEmpty) 'promo_code': promoCode,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }
}

