import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../auth/models/user_model.dart';
import '../models/check_auth_response_model.dart';
import '../services/settings_service.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final SettingsService _settingsService;

  UserInfoCubit(this._settingsService) : super(UserInfoInitial());

  /// Fetch user info and orders
  Future<void> checkAuth() async {
    emit(UserInfoLoading());

    try {
      final response = await _settingsService.checkAuth();

      final checkAuthResponse = CheckAuthResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      emit(UserInfoSuccess(
        user: checkAuthResponse.data,
        orders: checkAuthResponse.data.orders,
      ));
    } catch (e) {
      String errorMessage = 'Failed to load user info. Please try again.';

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

      emit(UserInfoFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(UserInfoInitial());
  }

  Future<String?> deleteAccount() async {
    try {
      await _settingsService.deleteAccount();
      return null;
    } catch (e) {
      String errorMessage = 'Failed to delete account. Please try again.';

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

      return errorMessage;
    }
  }
}




