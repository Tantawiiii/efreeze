part of 'login_cubit.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseModel loginResponse;

  const LoginSuccess(this.loginResponse);
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);
}

