class UpdateProfileRequestModel {
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String? avatar;

  UpdateProfileRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
    };

    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }

    if (avatar != null) {
      data['avatar'] = avatar;
    }

    return data;
  }
}






