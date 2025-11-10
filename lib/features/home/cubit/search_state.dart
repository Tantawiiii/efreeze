part of 'search_cubit.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final ProductsListResponseModel response;

  const SearchSuccess(this.response);
}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure(this.message);
}









