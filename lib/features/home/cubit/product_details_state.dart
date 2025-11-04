part of 'product_details_cubit.dart';

abstract class ProductDetailsState {
  const ProductDetailsState();
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsSuccess extends ProductDetailsState {
  final ProductDetailsResponseModel response;

  const ProductDetailsSuccess(this.response);
}

class ProductDetailsFailure extends ProductDetailsState {
  final String message;

  const ProductDetailsFailure(this.message);
}

class AddToCartLoading extends ProductDetailsState {}

class AddToCartSuccess extends ProductDetailsState {
  final AddToCartResponseModel response;

  const AddToCartSuccess(this.response);
}

class AddToCartFailure extends ProductDetailsState {
  final String message;

  const AddToCartFailure(this.message);
}

