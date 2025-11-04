part of 'category_products_cubit.dart';

abstract class CategoryProductsState {
  const CategoryProductsState();
}

class CategoryProductsInitial extends CategoryProductsState {}

class CategoryProductsLoading extends CategoryProductsState {}

class CategoryProductsSuccess extends CategoryProductsState {
  final CategoryDetailsResponseModel response;

  const CategoryProductsSuccess(this.response);
}

class CategoryProductsFailure extends CategoryProductsState {
  final String message;

  const CategoryProductsFailure(this.message);
}

