part of 'categories_cubit.dart';

abstract class CategoriesState {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {
  final CategoriesResponseModel response;

  const CategoriesSuccess(this.response);
}

class CategoriesFailure extends CategoriesState {
  final String message;

  const CategoriesFailure(this.message);
}

