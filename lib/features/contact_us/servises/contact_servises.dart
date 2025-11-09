import 'package:dio/dio.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../../contact_us/models/contact_us_request_model.dart';

class ContactService {
  final ApiService _apiService;

  ContactService(this._apiService);

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

}



