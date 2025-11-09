part of 'contact_us_cubit.dart';

abstract class ContactUsState {
  const ContactUsState();
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final ContactUsResponseModel response;

  const ContactUsSuccess(this.response);
}

class ContactUsFailure extends ContactUsState {
  final String message;

  const ContactUsFailure(this.message);
}