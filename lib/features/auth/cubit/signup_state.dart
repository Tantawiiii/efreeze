part of 'signup_cubit.dart';

abstract class SignupState {
  const SignupState();
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final dynamic data;

  const SignupSuccess(this.data);
}

class SignupFailure extends SignupState {
  final String message;

  const SignupFailure(this.message);
}

