import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/settings_service.dart';
import '../models/contact_us_request_model.dart';
import '../models/contact_us_response_model.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final SettingsService _settingsService;

  ContactUsCubit(this._settingsService) : super(ContactUsInitial());

  /// Send contact us message
  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    emit(ContactUsLoading());

    try {
      final request = ContactUsRequestModel(
        name: name,
        email: email,
        phone: phone,
        message: message,
      );

      final response = await _settingsService.contactUs(request);

      final responseData = response.data as Map<String, dynamic>;
      final contactUsResponse = ContactUsResponseModel.fromJson(responseData);

      emit(ContactUsSuccess(contactUsResponse));
    } catch (e) {
      String errorMessage = 'Failed to send message. Please try again.';

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

      emit(ContactUsFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(ContactUsInitial());
  }
}

