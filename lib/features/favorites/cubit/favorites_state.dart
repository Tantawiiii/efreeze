part of 'favorites_cubit.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final FavoritesResponseModel response;
  final Set<int> favoriteIds;

  const FavoritesSuccess(this.response, {required this.favoriteIds});

  bool isFavorite(int cardId) => favoriteIds.contains(cardId);

  List<FavoriteItemModel> get items => response.data;
}

class FavoritesFailure extends FavoritesState {
  final String message;

  const FavoritesFailure(this.message);
}
