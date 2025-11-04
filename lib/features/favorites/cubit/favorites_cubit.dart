import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../home/services/products_service.dart';
import '../models/favorites_response_model.dart';
import '../models/add_favorite_response_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final ProductsService _productsService;

  FavoritesCubit(this._productsService) : super(FavoritesInitial());

  /// Get all favorites
  Future<void> getFavorites() async {
    emit(FavoritesLoading());

    try {
      final response = await _productsService.getFavorites();

      emit(FavoritesSuccess(response));
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

      emit(FavoritesFailure(errorMessage));
    }
  }

  /// Toggle favorite (add or remove)
  Future<void> toggleFavorite({
    required int cardId,
    required String method,
  }) async {
    try {
      final response = await _productsService.toggleFavorite(
        cardId: cardId,
        method: method,
      );

      emit(ToggleFavoriteSuccess(response));
      
      // Refresh favorites list after toggle
      await getFavorites();
    } catch (e) {
      String errorMessage = 'Failed to update favorite. Please try again.';

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
        }
      }

      emit(ToggleFavoriteFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(FavoritesInitial());
  }
}

