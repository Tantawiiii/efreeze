class AddReviewRequestModel {
  final int rating;
  final String comment;

  AddReviewRequestModel({
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
    };
  }
}

