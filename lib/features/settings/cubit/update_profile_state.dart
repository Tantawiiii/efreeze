part of 'update_profile_cubit.dart';

abstract class UpdateProfileState {
  const UpdateProfileState();
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final UpdateProfileResponseModel response;

  const UpdateProfileSuccess(this.response);
}

class UpdateProfileFailure extends UpdateProfileState {
  final String message;

  const UpdateProfileFailure(this.message);
}









