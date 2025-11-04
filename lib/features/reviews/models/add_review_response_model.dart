class ReviewDataModel {
  final int id;
  final int userId;
  final int rating;
  final String comment;
  final int cardId;
  final String createdAt;
  final String updatedAt;

  ReviewDataModel({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.cardId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewDataModel.fromJson(Map<String, dynamic> json) {
    return ReviewDataModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      cardId: json['card_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'card_id': cardId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AddReviewResponseModel {
  final String result;
  final ReviewDataModel data;
  final String message;
  final int status;

  AddReviewResponseModel({
    required this.result,
    required this.data,
    required this.message,
    required this.status,
  });

  factory AddReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return AddReviewResponseModel(
      result: json['result'] as String,
      data: ReviewDataModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.toJson(),
      'message': message,
      'status': status,
    };
  }
}

