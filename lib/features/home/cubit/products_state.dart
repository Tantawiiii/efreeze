part of 'products_cubit.dart';

abstract class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final ProductsListResponseModel response;

  const ProductsSuccess(this.response);
}

class ProductsFailure extends ProductsState {
  final String message;

  const ProductsFailure(this.message);
}

