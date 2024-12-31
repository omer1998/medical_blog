part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthLogOutSuccess extends AuthState {}

class AuthLogOutFailure extends AuthState {
  final String message;

  AuthLogOutFailure(this.message);
}

// Profile update states
class ProfileUpdateLoading extends AuthState {}

class ProfileUpdateSuccess extends AuthState {}

class ProfileUpdateFailure extends AuthState {
  final String message;

  ProfileUpdateFailure(this.message);
}
