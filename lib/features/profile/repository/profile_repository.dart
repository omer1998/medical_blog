import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/profile_local_datasource.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/storage.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
      ref: ref,
      profileLocalDatasource: ref.read(profileLocalDatasourceProvider));
});

class ProfileRepository {
  final ProfileLocalDatasource profileLocalDatasource;
  final Ref ref;

  ProfileRepository({required this.profileLocalDatasource, required this.ref});

  Future<List<MyCase>> getUserCases(String userId) async {
    try {
      // print("cases: ${await isConnected()}");
      if (await isConnected()) {
        // print("cases");
        final cases = await ref.read(supabaseClientProvider).from("cases").select().eq("case_author", userId);
        // print("cases: $cases");
       final casesModels= cases.map((element){
       return  MyCase.fromMap(element);
       }).toList();
        return casesModels;
      } else {
        throw ServerException("No Internet Connection");
      }
  }catch (e) {
    rethrow;
  }
  }
  Future<List<BlogModel>> getUserBlogs(String userId) async {
    try {
      // print("cases: ${await isConnected()}");
      if (await isConnected()) {
        // print("cases");
        final blogs = await ref.read(supabaseClientProvider).from("blogs").select().eq("author_id", userId);
       final blogModels= blogs.map((element){
       return  BlogModel.fromMap(element);
       }).toList();
        return blogModels;
      } else {
        throw ServerException("No Internet Connection");
      }
  }catch (e) {
    rethrow;
  }
  }
  Future<UserEntity> getUserProfileInfo(String userId)async{
    try {
     if (await isConnected()) {
      final userData = await ref.read(supabaseClientProvider).from("profiles").select().eq("id", userId).single();
      final userModel = UserModel.fromJson(userData);
      print("object: $userModel" );
      return userModel;
     }else {
      throw ServerException('No internet connection');
     }
      
    } on ServerException  {
      rethrow;
    } catch (e) {
      throw ServerException("${e.toString()} error fetching user profile info");
    }
  }
  Future<bool> updatePassword(String password) async {
    try {
      print("passsssssssssssssss");
      print(password);
      if (password.isEmpty) {
        throw AuthException('Password is required');
      } else if (password.length < 8) {
        throw AuthException('Password must be at least 8 characters long');
      }

      final userResponse = await ref
          .read(supabaseClientProvider)
          .auth
          .updateUser(UserAttributes(password: password));
      print("user response");
      print(userResponse);
      return true;
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw AuthApiException("Email Is Required");
      }
      final userResponse = await ref
          .read(supabaseClientProvider)
          .auth
          .updateUser(UserAttributes(email: email));
      await ref
          .read(supabaseClientProvider)
          .from("profiles")
          .update({"email": email}).eq("id", userResponse.user!.id);

      print("user response");
      print(userResponse);
      return (true);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<Failure, void>> updateEmailPassword(
      String email, String password) async {
    try {
      // await updateEmail(email);
      await updatePassword(password);
      return right(null);
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateProfileInfo(UserModel user) async {
    try {
      // ref.read(supabaseClientProvider).auth.updateUser(UserAttributes())
      await ref.read(supabaseClientProvider).from("profiles").update({
        "about": user.about,
        // "email": user.email,
        "name": user.name,
      }).eq("id", user.id);
      // await ref.read(supabaseClientProvider).auth.updateUser(UserAttributes(
      //   email: user.email,

      // ));

      //update user in local db
      await profileLocalDatasource.saveUser(user);

      return right(null);
    } on PostgrestException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> updateProfileImg(
      File image, UserModel user) async {
    try {
      // ref.read(supabaseClientProvider).auth.updateUser(UserAttributes())
      // ref.read(storageProvider).saveProfileImgUrl(img, userId)
      final updatedImgUrl = await ref
          .read(storageProvider)
          .saveProfileImg(image, "${user.name}/${user.id}");
      // print("img_url: ${updatedImgUrl}");
      await ref
          .read(supabaseClientProvider)
          .from("profiles")
          .update({"img_url": updatedImgUrl}).eq("id", user.id);
      final updatedUser = user.copyWith(
          img_url: "${updatedImgUrl}?${DateTime.now().millisecondsSinceEpoch}");
      // print("updated user: $updatedUser

      //  update the user in local db
      await profileLocalDatasource.saveUser(updatedUser);

      return right(updatedUser);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  // Future<Either<Failure,void>> updateEmailPassword(UserModel user, String password) async {
  //   try {
  //     await ref.read(supabaseClientProvider).from("profiles").update({
  //     "email":user.email,

  //   });
  //   await ref.read(supabaseClientProvider).auth.updateUser(UserAttributes(
  //     email: user.email,
  //     password: password
  //   ));
  //   return right(null);
  //   } catch (e) {
  //    return left(Failure(message:e.toString()));
  //   }

  // }

  showUserFromLocalDb() async {
    try {
      print(await profileLocalDatasource.getUser());
    } on LocalStorageException catch (e) {
      print(e.message);
    }
    return;
  }
}
