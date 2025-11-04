class ContactUsDataModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final String createdAt;
  final String updatedAt;

  ContactUsDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactUsDataModel.fromJson(Map<String, dynamic> json) {
    return ContactUsDataModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      message: json['message'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ContactUsResponseModel {
  final ContactUsDataModel? data;
  final String? result;
  final String? message;
  final int? status;

  ContactUsResponseModel({
    this.data,
    this.result,
    this.message,
    this.status,
  });

  factory ContactUsResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactUsResponseModel(
      data: json['data'] != null
          ? ContactUsDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      result: json['result'] as String?,
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'result': result,
      'message': message,
      'status': status,
    };
  }
}

