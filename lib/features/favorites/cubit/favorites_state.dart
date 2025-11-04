part of 'favorites_cubit.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final FavoritesResponseModel response;

  const FavoritesSuccess(this.response);
}

class FavoritesFailure extends FavoritesState {
  final String message;

  const FavoritesFailure(this.message);
}

class ToggleFavoriteSuccess extends FavoritesState {
  final AddFavoriteResponseModel response;

  const ToggleFavoriteSuccess(this.response);
}

class ToggleFavoriteFailure extends FavoritesState {
  final String message;

  const ToggleFavoriteFailure(this.message);
}

