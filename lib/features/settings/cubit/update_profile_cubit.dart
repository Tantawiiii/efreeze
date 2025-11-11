import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../auth/services/auth_service.dart';
import '../models/update_profile_response_model.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final AuthService _authService;

  UpdateProfileCubit(this._authService) : super(UpdateProfileInitial());

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? password,
    File? avatar,
  }) async {
    emit(UpdateProfileLoading());

    try {
      final response = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        password: password,
        avatar: avatar,
      );

      final updateProfileResponse = UpdateProfileResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      emit(UpdateProfileSuccess(updateProfileResponse));
    } catch (e) {
      String errorMessage = 'Failed to update profile. Please try again.';

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

      emit(UpdateProfileFailure(errorMessage));
    }
  }

  void reset() {
    emit(UpdateProfileInitial());
  }
}


