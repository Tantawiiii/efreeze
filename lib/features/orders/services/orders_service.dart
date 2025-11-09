import 'package:dio/dio.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';

class OrdersService {
  final ApiService _apiService;

  OrdersService(this._apiService);



  Future<Response> getOrderDetails(String orderNumber) async {
    try {
      final response = await _apiService.get(
        ApiConstants.orderDetails(orderNumber),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> changeOrderStatus({
    required int orderId,
    required String status,
  }) async

  {
    try {
      final response = await _apiService.post(
        ApiConstants.orderChangeStatus(orderId),
        data: {
          'status': status,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteOrder(int orderId) async {
    try {
      final response = await _apiService.delete(
        ApiConstants.deleteOrder(orderId),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}



