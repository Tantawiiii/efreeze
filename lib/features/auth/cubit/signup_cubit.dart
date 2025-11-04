import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthService _authService;

  SignupCubit(this._authService) : super(SignupInitial());

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    File? avatar,
  }) async {
    emit(SignupLoading());

    try {
      final response = await _authService.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
        avatar: avatar,
      );

      emit(SignupSuccess(response.data));
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
          errorMessage = 'Connection timeout. Please check your internet connection.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        }
      }

      emit(SignupFailure(errorMessage));
    }
  }

  void reset() {
    emit(SignupInitial());
  }
}

