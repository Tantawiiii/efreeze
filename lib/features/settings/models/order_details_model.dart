import 'order_card_item_model.dart';

class OrderDetailsModel {
  final int id;
  final String name;
  final String email;
  final String orderNumber;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String status;
  final String zipCode;
  final String paymentMethod;
  final String paymentStatus;
  final String? promoCode;
  final List<OrderCardItemModel> cards;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  OrderDetailsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.orderNumber,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.status,
    required this.zipCode,
    required this.paymentMethod,
    required this.paymentStatus,
    this.promoCode,
    required this.cards,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      orderNumber: json['order_number'] as String,
      phone: json['phone'] as String,
      addressLine: json['address_line'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      status: json['status'] as String,
      zipCode: json['zip_code'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      promoCode: json['promo_code'] as String?,
      cards:
          (json['cards'] as List<dynamic>?)
              ?.map(
                (item) =>
                    OrderCardItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'order_number': orderNumber,
      'phone': phone,
      'address_line': addressLine,
      'city': city,
      'state': state,
      'status': status,
      'zip_code': zipCode,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'promo_code': promoCode,
      'cards': cards.map((c) => c.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}


