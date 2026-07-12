import 'dart:io';
import 'package:bloc/bloc.dart';
import '../../../core/network/api_error_parser.dart';
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
      emit(SignupFailure(ApiErrorParser.parse(e)));
    }
  }

  void reset() {
    emit(SignupInitial());
  }
}
