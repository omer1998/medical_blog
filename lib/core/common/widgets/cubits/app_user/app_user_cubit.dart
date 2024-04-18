import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_blog_app/core/entities/user.dart';

part 'app_user_state.dart';
// the main purpose of this cubit state is to make the user object/ model accessible across all app features

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(UserLoggedInState(user: user));
    }
  }
}

// I NEED TO UPDATE USER STATE in every log in / sign up