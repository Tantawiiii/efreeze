import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../models/order_details_model.dart';
import '../models/order_details_response_model.dart';
import '../services/settings_service.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final SettingsService _settingsService;

  OrderDetailsCubit(this._settingsService) : super(OrderDetailsInitial());

  /// Fetch order details
  Future<void> getOrderDetails(String orderNumber) async {
    emit(OrderDetailsLoading());

    try {
      final response = await _settingsService.getOrderDetails(orderNumber);

      final orderDetailsResponse = OrderDetailsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      emit(OrderDetailsSuccess(orderDetailsResponse.data));
    } catch (e) {
      String errorMessage = 'Failed to load order details. Please try again.';

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

      emit(OrderDetailsFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(OrderDetailsInitial());
  }
}



