import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;
  final StorageService _storageService;
  final DioClient _dioClient;

  LoginCubit(this._authService, this._storageService, this._dioClient)
    : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final loginResponse = LoginResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      await _storageService.saveLoginResponse(loginResponse);
      _dioClient.setAuthToken(loginResponse.token);

      emit(LoginSuccess(loginResponse));
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

      emit(LoginFailure(errorMessage));
    }
  }

  void reset() {
    emit(LoginInitial());
  }
}
