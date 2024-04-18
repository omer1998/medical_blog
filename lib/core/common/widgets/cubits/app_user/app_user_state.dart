part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial
    extends AppUserState {} // this state mean the user is logged out

final class UserLoggedInState extends AppUserState {
  final UserEntity user;

  UserLoggedInState({required this.user});
}

// look in common folder --> common canot depend on  features but feature can depend on common
// that's why we need to put entity folder inside common folder