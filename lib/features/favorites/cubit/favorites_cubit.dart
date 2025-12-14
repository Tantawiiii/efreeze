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
  Future<void> getFavorites({bool forceRefresh = false}) async {
    // Don't reload if we already have data unless force refresh
    if (!forceRefresh && state is FavoritesSuccess) {
      return;
    }

    // Check if cubit is closed before emitting
    if (isClosed) return;

    emit(FavoritesLoading());

    try {
      final response = await _productsService.getFavorites();

      if (isClosed) return;
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

      if (isClosed) return;
      emit(FavoritesFailure(errorMessage));
    }
  }

  /// Toggle favorite (add or remove)
  Future<void> toggleFavorite({
    required int cardId,
    required String method,
  }) async {
    if (isClosed) return;

    try {
      final response = await _productsService.toggleFavorite(
        cardId: cardId,
        method: method,
      );

      if (isClosed) return;
      emit(ToggleFavoriteSuccess(response));

      // Refresh favorites list after toggle (force refresh)
      await getFavorites(forceRefresh: true);
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

      if (isClosed) return;
      emit(ToggleFavoriteFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    if (isClosed) return;
    emit(FavoritesInitial());
  }
}
