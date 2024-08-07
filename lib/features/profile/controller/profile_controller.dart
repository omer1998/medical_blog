import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/storage.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/profile/page/profile_page.dart';
import 'package:medical_blog_app/features/profile/repository/profile_repository.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  return ProfileController(ref: ref);
});

class ProfileController extends StateNotifier<bool> {
  final Ref ref;

  ProfileController({required this.ref}) : super(false);
  updateImgUrl(File image, UserModel user, BuildContext context) async {
    state = true;
    final res =
        await ref.read(profileRepositoryProvider).updateProfileImg(image, user);

    res.fold((f) {
      state = false;
      showSnackBar(context, f.message);
    }, (updatedUser) {
      state = false;
      BlocProvider.of<AppUserCubit>(context).updateUser(updatedUser);
      showSnackBar(context, "Profile image updated successfully");
      GoRouter.of(context).goNamed("profile", extra: updatedUser);
    });
  }

  updateProfileInfo(UserModel user, BuildContext context) async {
    // TODO: implement updateProfileInfo
    state = true;
    final res =
        await ref.read(profileRepositoryProvider).updateProfileInfo(user);
    state = false;
    res.fold((f) {
      showSnackBar(context, f.message);
    }, (v) {
      BlocProvider.of<AppUserCubit>(context).updateUser(user);
      showSnackBar(context, "profile info updated successfuly");
      print("show user info saved locally");
      GoRouter.of(context).goNamed("profile", extra: user);
    });
  }

  updateEmailPassword(
      String email, String password, BuildContext context) async {
    state = true;
    final res = await ref
        .read(profileRepositoryProvider)
        .updateEmailPassword(email, password);
    res.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) {
      state = false;

      showSnackBar(context, "Credentials updated successfully");
      Navigator.of(context).pop();
    });
  }
}
