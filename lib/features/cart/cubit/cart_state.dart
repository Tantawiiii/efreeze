part of 'cart_cubit.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponseModel response;

  const CartSuccess(this.response);
}

class CartFailure extends CartState {
  final String message;

  const CartFailure(this.message);
}

