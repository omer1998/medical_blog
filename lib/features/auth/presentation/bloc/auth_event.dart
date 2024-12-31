part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });
}

class UpdateProfileEvent extends AuthEvent {
  final String name;
  final File imageFile;
  final String? title;
  final String? about;
  final String? specialization;
  final String? institution;
  final List<String>? expertise;
  final Map<String, String>? socialLinks;

  UpdateProfileEvent({
    required this.name,
    required this.imageFile,
    this.title,
    this.about,
    this.specialization,
    this.institution,
    this.expertise,
    this.socialLinks,
  });
}

class UserStateEvent extends AuthEvent {
  final NoParams noParams;
  UserStateEvent({required this.noParams});
}

class LogOutEvent extends AuthEvent {
  final NoParams noParams;
  final BuildContext context;

  LogOutEvent({required this.noParams, required this.context});
}