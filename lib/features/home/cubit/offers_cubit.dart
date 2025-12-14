import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/products_service.dart';
import '../models/offers_response_model.dart';

part 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final ProductsService _productsService;

  OffersCubit(this._productsService) : super(OffersInitial());

  /// Get all offers
  Future<void> getOffers({bool forceRefresh = false}) async {
    // Don't reload if we already have data unless force refresh
    if (!forceRefresh && state is OffersSuccess) {
      return;
    }

    // Check if cubit is closed before emitting
    if (isClosed) return;

    emit(OffersLoading());

    try {
      final response = await _productsService.getOffers();

      if (isClosed) return;
      emit(OffersSuccess(response));
    } catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

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

      if (isClosed) return;
      emit(OffersFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    if (isClosed) return;
    emit(OffersInitial());
  }
}
