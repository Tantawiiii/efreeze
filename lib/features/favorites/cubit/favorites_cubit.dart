import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../home/services/products_service.dart';
import '../models/favorites_response_model.dart';
import '../models/favorite_item_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final ProductsService _productsService;
  final Set<int> _inFlightToggles = {};

  FavoritesCubit(this._productsService) : super(FavoritesInitial());

  static List<FavoriteItemModel> _dedupeFavorites(
    List<FavoriteItemModel> items,
  ) {
    final seen = <int>{};
    final deduped = <FavoriteItemModel>[];

    for (final item in items.reversed) {
      final cardId = item.card.id;
      if (seen.add(cardId)) {
        deduped.add(item);
      }
    }

    return deduped.reversed.toList();
  }

  static Set<int> _idsFrom(List<FavoriteItemModel> items) {
    return items.map((item) => item.card.id).toSet();
  }

  Future<void> getFavorites({bool forceRefresh = false}) async {
    if (isClosed) return;

    final hasData = state is FavoritesSuccess;
    if (!forceRefresh && hasData) {
      return;
    }

    // Keep current favorites visible while refreshing to avoid icon flicker.
    if (!hasData) {
      emit(FavoritesLoading());
    }

    try {
      final response = await _productsService.getFavorites();
      if (isClosed) return;

      final deduped = _dedupeFavorites(response.data);
      emit(
        FavoritesSuccess(
          FavoritesResponseModel(
            result: response.result,
            data: deduped,
            message: response.message,
            status: response.status,
          ),
          favoriteIds: _idsFrom(deduped),
        ),
      );
    } catch (e) {
      if (isClosed) return;

      // Keep previous list on refresh failure.
      if (hasData) {
        debugPrint('Favorites refresh failed: $e');
        return;
      }

      emit(FavoritesFailure(_errorMessage(e, 'An error occurred. Please try again.')));
    }
  }

  /// Returns an error message on failure, otherwise null.
  Future<String?> toggleFavorite({
    required int cardId,
    required String method,
  }) async {
    if (isClosed) return 'Favorites unavailable';
    if (_inFlightToggles.contains(cardId)) return null;

    _inFlightToggles.add(cardId);

    final previousState = state is FavoritesSuccess
        ? state as FavoritesSuccess
        : null;
    final previousItems = previousState?.items ?? const <FavoriteItemModel>[];
    final previousIds = Set<int>.from(
      previousState?.favoriteIds ?? const <int>{},
    );

    // Optimistic update so heart stays in sync immediately.
    if (method == 'delete') {
      previousIds.remove(cardId);
      final updatedItems = previousItems
          .where((fav) => fav.card.id != cardId)
          .toList();
      if (!isClosed) {
        emit(
          FavoritesSuccess(
            FavoritesResponseModel(
              result: previousState?.response.result ?? 'Success',
              data: updatedItems,
              message: previousState?.response.message ?? '',
              status: previousState?.response.status ?? 200,
            ),
            favoriteIds: previousIds,
          ),
        );
      }
    } else {
      previousIds.add(cardId);
      if (!isClosed) {
        emit(
          FavoritesSuccess(
            FavoritesResponseModel(
              result: previousState?.response.result ?? 'Success',
              data: previousItems,
              message: previousState?.response.message ?? '',
              status: previousState?.response.status ?? 200,
            ),
            favoriteIds: previousIds,
          ),
        );
      }
    }

    try {
      await _productsService.toggleFavorite(cardId: cardId, method: method);
      if (isClosed) return null;

      // Always sync with server so added items include full card data
      // and duplicates from the API are removed.
      await _refreshFavoritesSilently();
      return null;
    } catch (e) {
      if (!isClosed && previousState != null) {
        emit(previousState);
      }

      return _errorMessage(e, 'Failed to update favorite. Please try again.');
    } finally {
      _inFlightToggles.remove(cardId);
    }
  }

  Future<void> _refreshFavoritesSilently() async {
    if (isClosed) return;

    try {
      final response = await _productsService.getFavorites();
      if (isClosed) return;

      final deduped = _dedupeFavorites(response.data);
      emit(
        FavoritesSuccess(
          FavoritesResponseModel(
            result: response.result,
            data: deduped,
            message: response.message,
            status: response.status,
          ),
          favoriteIds: _idsFrom(deduped),
        ),
      );
    } catch (e) {
      debugPrint('Silent favorites refresh failed: $e');
    }
  }

  void reset() {
    if (isClosed) return;
    _inFlightToggles.clear();
    emit(FavoritesInitial());
  }

  String _errorMessage(Object e, String fallback) {
    if (e is DioException) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return errorData['message'].toString();
        }
        if (errorData is Map && errorData.containsKey('error')) {
          return errorData['error'].toString();
        }
        return e.response?.statusMessage ?? fallback;
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return 'Connection timeout. Please check your internet connection.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network.';
      }
    }
    return fallback;
  }
}
