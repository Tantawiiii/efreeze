import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../home/services/products_service.dart';
import '../models/create_order_request_model.dart';
import '../models/create_order_response_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final ProductsService _productsService;

  OrderCubit(this._productsService) : super(OrderInitial());

  /// Create order
  Future<void> createOrder(CreateOrderRequestModel orderData) async {
    emit(OrderLoading());

    try {
      final response = await _productsService.createOrder(orderData);

      emit(OrderSuccess(response));
    } catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          } else if (errorData is Map && errorData.containsKey('error')) {
            errorMessage = errorData['error'].toString();
          } else {
            errorMessage = e.response?.statusMessage ?? errorMessage;
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage =
              'Connection timeout. Please check your internet connection.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        }
      }

      emit(OrderFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(OrderInitial());
  }
}

