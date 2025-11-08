import 'package:dio/dio.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../models/contact_us_request_model.dart';

class SettingsService {
  final ApiService _apiService;

  SettingsService(this._apiService);

  Future<Response> contactUs(ContactUsRequestModel request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.contactUs,
        data: request.toJson(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> checkAuth() async {
    try {
      final response = await _apiService.get(ApiConstants.checkAuth);
      return response;
    } catch (e) {
      rethrow;
    }
  }

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
}



