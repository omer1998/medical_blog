part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}

class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

// final class UserLoggedInState extends AuthState {
//   final UserEntity user;

//   UserLoggedInState({required this.user});
// }

// final class UserNotLoggedInState extends AuthState {
//   final String message;

//   UserNotLoggedInState({required this.message});
// }
