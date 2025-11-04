part of 'order_cubit.dart';

abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final CreateOrderResponseModel response;

  const OrderSuccess(this.response);
}

class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);
}

