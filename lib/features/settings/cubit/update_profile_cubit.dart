import 'dart:io';
import 'package:bloc/bloc.dart';
import '../../../core/network/api_error_parser.dart';
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
      emit(
        UpdateProfileFailure(
          ApiErrorParser.parse(
            e,
            fallback: 'Failed to update profile. Please try again.',
          ),
        ),
      );
    }
  }

  void reset() {
    emit(UpdateProfileInitial());
  }
}


