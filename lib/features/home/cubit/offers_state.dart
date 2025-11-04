part of 'offers_cubit.dart';

abstract class OffersState {
  const OffersState();
}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersSuccess extends OffersState {
  final OffersResponseModel response;

  const OffersSuccess(this.response);
}

class OffersFailure extends OffersState {
  final String message;

  const OffersFailure(this.message);
}

