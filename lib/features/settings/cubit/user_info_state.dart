part of 'user_info_cubit.dart';

abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoSuccess extends UserInfoState {
  final UserModel user;
  final List<dynamic> orders;

  UserInfoSuccess({required this.user, required this.orders});
}

class UserInfoFailure extends UserInfoState {
  final String message;

  UserInfoFailure(this.message);
}



