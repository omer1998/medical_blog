import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get userSession;
  Future<UserModel?> getUser();
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password);
  Future<UserModel> logInWithEmailAndPassword(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<UserModel> logInWithEmailAndPassword(
      String email, String password) async {
    try {
      final res = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (res.user != null) {
        return UserModel.fromJson(res.user!.toJson());
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
          .signUp(email: email, password: password, data: {"name": name});
      if (res.user == null) {
        throw ServerException("User is NULL");
      }
      return UserModel.fromJson(res.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
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
        final user = UserModel.fromJson(query.first)
            .copyWith(email: userSession!.user.email);
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
}
