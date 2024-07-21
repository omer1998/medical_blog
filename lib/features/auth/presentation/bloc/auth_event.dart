part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SignUpEvent extends AuthEvent {
  final SignUpData data;

  SignUpEvent(this.data);
}

final class SignInEvent extends AuthEvent {
  final SignInData data;

  SignInEvent({required this.data});
}

final class UserStateEvent extends AuthEvent {
  final NoParams noParams;

  UserStateEvent({required this.noParams});
}

final class LogOutEvent extends AuthEvent {
  final NoParams noParams;
  final BuildContext context;

  LogOutEvent({required this.noParams, required this.context});


}