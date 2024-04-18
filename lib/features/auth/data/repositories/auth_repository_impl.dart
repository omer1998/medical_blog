import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';

import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future<Either<Failure, UserModel>> logInWithEmailPassword(
      {required email, required password}) async {
    try {
      final user =
          await authRemoteDataSource.logInWithEmailAndPassword(email, password);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } on AuthException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassword(
      {required name, required email, required password}) async {
    try {
      final userModel = await authRemoteDataSource.signUpWithEmailAndPassword(
          name, email, password);
      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUser() async {
    try {
      final user = await authRemoteDataSource.getUser();
      if (user != null) {
        return right(user);
      } else {
        return right(null);
      }
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
