import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../home/services/products_service.dart';
import '../models/favorites_response_model.dart';
import '../models/add_favorite_response_model.dart';
import '../models/favorite_item_model.dart';

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

    // Optimistically update the current state if we have favorites loaded
    FavoritesResponseModel? previousFavorites;
    if (state is FavoritesSuccess) {
      previousFavorites = (state as FavoritesSuccess).response;
    }

    try {
      final response = await _productsService.toggleFavorite(
        cardId: cardId,
        method: method,
      );

      if (isClosed) return;

      // Update favorites list optimistically without refetching
      if (previousFavorites != null) {
        if (method == 'delete') {
          // Optimistically remove the favorite from the list
          final updatedData = List<FavoriteItemModel>.from(
            previousFavorites.data,
          );
          updatedData.removeWhere((fav) => fav.card.id == cardId);

          // Emit updated state without going through loading
          emit(
            FavoritesSuccess(
              FavoritesResponseModel(
                result: previousFavorites.result,
                data: updatedData,
                message: previousFavorites.message,
                status: previousFavorites.status,
              ),
            ),
          );
        } else {
          // For 'add', we need the full card data which we don't have
          // Refresh silently in background without showing loading state
          _refreshFavoritesSilently();
        }
      } else {
        // If we don't have previous state, refresh silently
        _refreshFavoritesSilently();
      }
    } catch (e) {
      // Revert to previous state on error
      if (previousFavorites != null && !isClosed) {
        emit(FavoritesSuccess(previousFavorites));
      }

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

  /// Refresh favorites silently without emitting loading state
  Future<void> _refreshFavoritesSilently() async {
    if (isClosed) return;

    try {
      final response = await _productsService.getFavorites();
      if (isClosed) return;
      // Only emit if we're still in a state that needs updating
      if (state is! FavoritesSuccess ||
          (state as FavoritesSuccess).response.data.length !=
              response.data.length) {
        emit(FavoritesSuccess(response));
      }
    } catch (e) {
      // Silently fail - don't emit error state to avoid disrupting UI
      debugPrint('Silent favorites refresh failed: $e');
    }
  }

  /// Reset to initial state
  void reset() {
    if (isClosed) return;
    emit(FavoritesInitial());
  }
}
