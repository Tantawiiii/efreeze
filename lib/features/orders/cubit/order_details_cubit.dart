import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:efreeze/features/orders/services/orders_service.dart';
import '../models/order_details_model.dart';
import '../models/order_details_response_model.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  static const orderNotLoadedKey = 'ORDER_NOT_LOADED';
  final OrdersService _settingsService;
  OrderDetailsModel? _currentOrder;

  OrderDetailsCubit(this._settingsService) : super(OrderDetailsInitial());

  Future<void> getOrderDetails(String orderNumber) async {
    emit(OrderDetailsLoading());

    try {
      final order = await _fetchOrderDetails(orderNumber);
      emit(OrderDetailsSuccess(order));
    } catch (e) {
      emit(
        OrderDetailsFailure(
          _mapErrorMessage(
            e,
            'Failed to load order details. Please try again.',
          ),
        ),
      );
    }
  }

  Future<String?> cancelOrder() async {
    final order = _currentOrder;
    if (order == null) {
      return orderNotLoadedKey;
    }

    emit(OrderDetailsSuccess(order, isActionInProgress: true));

    try {
      await _settingsService.changeOrderStatus(
        orderId: order.id,
        status: 'cancel',
      );

      final updatedOrder = await _fetchOrderDetails(order.orderNumber);
      emit(OrderDetailsSuccess(updatedOrder));
      return null;
    } catch (e) {
      final message = _mapErrorMessage(
        e,
        'Failed to cancel order. Please try again.',
      );
      emit(OrderDetailsSuccess(order, isActionInProgress: false));
      return message;
    }
  }

  Future<String?> deleteOrder() async {
    final order = _currentOrder;
    if (order == null) {
      return orderNotLoadedKey;
    }

    emit(OrderDetailsSuccess(order, isActionInProgress: true));

    try {
      await _settingsService.deleteOrder(order.id);
      _currentOrder = null;
      emit(OrderDetailsSuccess(order, isActionInProgress: false));
      return null;
    } catch (e) {
      final message = _mapErrorMessage(
        e,
        'Failed to delete order. Please try again.',
      );
      emit(OrderDetailsSuccess(order, isActionInProgress: false));
      return message;
    }
  }

  void reset() {
    _currentOrder = null;
    emit(OrderDetailsInitial());
  }

  Future<OrderDetailsModel> _fetchOrderDetails(String orderNumber) async {
    final response = await _settingsService.getOrderDetails(orderNumber);

    final orderDetailsResponse = OrderDetailsResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    _currentOrder = orderDetailsResponse.data;
    return _currentOrder!;
  }

  String _mapErrorMessage(Object error, String fallback) {
    String errorMessage = fallback;

    if (error is DioException) {
      if (error.response != null) {
        final errorData = error.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'].toString();
        } else if (errorData is Map && errorData.containsKey('error')) {
          errorMessage = errorData['error'].toString();
        } else {
          errorMessage = error.response?.statusMessage ?? errorMessage;
        }
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (error.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }
    }

    return errorMessage;
  }
}
