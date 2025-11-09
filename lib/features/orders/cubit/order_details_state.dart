part of 'order_details_cubit.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderDetailsModel order;
  final bool isActionInProgress;

  OrderDetailsSuccess(this.order, {this.isActionInProgress = false});
}

class OrderDetailsFailure extends OrderDetailsState {
  final String message;

  OrderDetailsFailure(this.message);
}



