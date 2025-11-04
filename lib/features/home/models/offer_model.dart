class OfferModel {
  final int id;
  final String title;
  final String description;
  final String product;
  final int productId;
  final String avatar;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.product,
    required this.productId,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      product: json['product'] as String,
      productId: json['product_id'] as int,
      avatar: json['avatar'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'product': product,
      'product_id': productId,
      'avatar': avatar,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

