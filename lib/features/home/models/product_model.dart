class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String shortDescription;
  final String oldPrice;
  final String discount;
  final String price;
  final String currency;
  final int quantity;
  final String? linkVideo;
  final String? image;
  final List<dynamic> gallery;
  final String category;
  final bool active;
  final double averageRating;
  final int reviewsCount;
  final String mobile;
  final String type;
  final String typeSilicone;
  final String hardness;
  final String bio;
  final String timeInEar;
  final String endCuring;
  final String viscosity;
  final String color;
  final String packaging;
  final String itemNumber;
  final String mixGun;
  final String mixCanules;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.shortDescription,
    required this.oldPrice,
    required this.discount,
    required this.price,
    required this.currency,
    required this.quantity,
    this.linkVideo,
    this.image,
    required this.gallery,
    required this.category,
    required this.active,
    required this.averageRating,
    required this.reviewsCount,
    required this.mobile,
    required this.type,
    required this.typeSilicone,
    required this.hardness,
    required this.bio,
    required this.timeInEar,
    required this.endCuring,
    required this.viscosity,
    required this.color,
    required this.packaging,
    required this.itemNumber,
    required this.mixGun,
    required this.mixCanules,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String,
      oldPrice: json['old_price'] as String,
      discount: json['discount'] as String,
      price: json['price'] as String,
      currency: json['currency'] as String,
      quantity: json['quantity'] as int,
      linkVideo: json['link_video'] as String?,
      image: json['image'] as String?,
      gallery: json['gallery'] as List<dynamic>? ?? [],
      category:
          json['category'] as String? ??
          (json['category_id'] != null ? json['category_id'].toString() : ''),
      active: json['active'] as bool,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      mobile: json['mobile'] as String? ?? '',
      type: json['type'] as String,
      typeSilicone: json['type_silicone'] as String,
      hardness: json['hardness'] as String,
      bio: json['bio'] as String,
      timeInEar: json['time_in_ear'] as String,
      endCuring: json['end_curing'] as String,
      viscosity: json['viscosity'] as String,
      color: json['color'] as String,
      packaging: json['packaging'] as String,
      itemNumber: json['item_number'] as String,
      mixGun: json['mix_gun'] as String,
      mixCanules: json['mix_canules'] as String,
      createdAt:
          json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
      updatedAt:
          json['updatedAt'] as String? ?? json['updated_at'] as String? ?? '',
      deletedAt: json['deletedAt'] as String? ?? json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'short_description': shortDescription,
      'old_price': oldPrice,
      'discount': discount,
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'link_video': linkVideo,
      'image': image,
      'gallery': gallery,
      'category': category,
      'active': active,
      'average_rating': averageRating,
      'reviews_count': reviewsCount,
      'mobile': mobile,
      'type': type,
      'type_silicone': typeSilicone,
      'hardness': hardness,
      'bio': bio,
      'time_in_ear': timeInEar,
      'end_curing': endCuring,
      'viscosity': viscosity,
      'color': color,
      'packaging': packaging,
      'item_number': itemNumber,
      'mix_gun': mixGun,
      'mix_canules': mixCanules,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
