part of 'review_cubit.dart';

abstract class ReviewState {
  const ReviewState();
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final AddReviewResponseModel response;

  const ReviewSuccess(this.response);
}

class ReviewFailure extends ReviewState {
  final String message;

  const ReviewFailure(this.message);
}

