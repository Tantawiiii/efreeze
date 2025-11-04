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
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      favorites: json['favorites'] as List<dynamic>? ?? [],
      orders: json['orders'] as List<dynamic>? ?? [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
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

