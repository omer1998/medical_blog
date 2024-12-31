// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';


abstract interface class AuthRemoteDataSource {
  Session? get userSession;
  Future<UserModel?> getUser();
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password);
  Future<UserModel> logInWithEmailAndPassword(String email, String password);
  Future<void> logOut();
   Future<Either<Failure, UserEntity>> updateProfile(UpdateProfileParams params);
}

// final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
//   final supabaseClient = ref.read(supabaseClientProvider);
//   return AuthRemoteDataSourceImpl(ref: ref, supabaseClient: supabaseClient);
// });

// class RefHolder {
//    WidgetRef? currentRef;

//   RefHolder({this.currentRef});

//   void updateRef(WidgetRef newRef) {
//     currentRef = newRef;
//   }
// }
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({
    // required this.ref,
    required this.supabaseClient,
  });
  @override
  Future<UserModel> logInWithEmailAndPassword(
      String email, String password) async {
    try {
      final res = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      print("res user");
      print(res.user!.toJson());
      print(res.user!.userMetadata);
      if (res.user != null) {
        final userData = await supabaseClient.from("profiles").select().eq("id", res.user!.id).single();
        print(userData);
        return UserModel.fromJson(userData);
      } else {
        throw ServerException("User is null !!");
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final res = await supabaseClient.auth
          .signUp(email: email, password: password, data: {"name": name,});
      if (res.user == null) {
        throw ServerException("User is NULL");
      }
      print("res: ${res.user!.toJson()}");
      return UserModel.fromJson(res.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      print("err in sign up : ${e.toString()}");
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get userSession {
    return supabaseClient.auth.currentSession;
  }

  // to get the most updated user
  @override
  Future<UserModel?> getUser() async {
    try {
      if (userSession != null) {
        final query = await supabaseClient
            .from("profiles")
            .select()
            .eq("id", userSession!.user.id);

            print("query of user");
            print(query);
        final user = UserModel.fromJson(query.first);
        // .copyWith(email: userSession!.user.email);
        // print("0000000000000000000");
        // refHolder.currentRef != null ? refHolder.currentRef!.read(appUserProvider.notifier).state = user  : null;
        // print(refHolder.currentRef!.read(appUserProvider.notifier).state);
        // print("0000000000000000000");
        return user;
      } else {
        return null;
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logOut() async {
    try {
      return await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> updateProfile(UpdateProfileParams params) async {
    try {
      // first upload image and get its url
      final imageName = "${params.name}${DateTime.now().millisecondsSinceEpoch}";
      await supabaseClient.storage.from("avatars").upload(imageName, params.imageFile);
      final img_url = supabaseClient.storage.from("avatars").getPublicUrl(imageName);
      final res = await supabaseClient.from("profiles").update({"img_url": img_url, 
        "title": params.title, "about": params.about, "specialization": params.specialization, "institution": params.institution, "expertise": params.expertise}).eq("id", userSession!.user.id).select();      
      // need to add current position
      print("image url: $img_url");
      print("res: ${res}");
      print(res.first);
      final user = UserModel.fromJson(res.first);
      return right(user);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
