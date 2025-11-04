import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../home/services/products_service.dart';
import '../models/add_review_request_model.dart';
import '../models/add_review_response_model.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ProductsService _productsService;

  ReviewCubit(this._productsService) : super(ReviewInitial());

  /// Add review for a product
  Future<void> addReview({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    emit(ReviewLoading());

    try {
      final reviewData = AddReviewRequestModel(
        rating: rating,
        comment: comment,
      );

      final response = await _productsService.addReview(
        productId: productId,
        reviewData: reviewData,
      );

      emit(ReviewSuccess(response));
    } catch (e) {
      String errorMessage = 'Failed to add review. Please try again.';

      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          } else if (errorData is Map && errorData.containsKey('error')) {
            errorMessage = errorData['error'].toString();
          } else {
            errorMessage = e.response?.statusMessage ?? errorMessage;
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage =
              'Connection timeout. Please check your internet connection.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        }
      }

      emit(ReviewFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(ReviewInitial());
  }
}

