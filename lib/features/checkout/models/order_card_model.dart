class OrderCardModel {
  final int id;
  final int qty;

  OrderCardModel({
    required this.id,
    required this.qty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
    };
  }
}

