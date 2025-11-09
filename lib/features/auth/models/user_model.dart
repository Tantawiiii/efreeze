class UserModel {
  final int id;
  final String name;
  final String phone;
  final String role;
  final String email;
  final String? avatar;
  final List<dynamic> favorites;
  final List<dynamic> orders;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.email,
    this.avatar,
    required this.favorites,
    required this.orders,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    List<dynamic> parseList(dynamic value) {
      if (value is List<dynamic>) return value;
      return [];
    }

    String? parseNullableString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    String parseString(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      return value.toString();
    }

    return UserModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      phone: parseString(json['phone']),
      role: parseString(json['role']),
      email: parseString(json['email']),
      avatar: parseNullableString(json['avatar']),
      favorites: parseList(json['favorites']),
      orders: parseList(json['orders']),
      createdAt: parseString(json['createdAt'] ?? json['created_at']),
      updatedAt: parseString(json['updatedAt'] ?? json['updated_at']),
      deletedAt: parseNullableString(json['deletedAt'] ?? json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'email': email,
      'avatar': avatar,
      'favorites': favorites,
      'orders': orders,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

