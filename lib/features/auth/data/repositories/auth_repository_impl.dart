// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/constants/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';
import 'package:medical_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';

import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });
  @override
  Future<Either<Failure, UserModel>> logInWithEmailPassword(
      {required email, required password}) async {
    try {
      if (!(await connectionChecker.isConnected)) {
        print("----- ??? true");

        return left(Failure(message: Constants.errorConnectionMessage));
      }
      final user =
          await authRemoteDataSource.logInWithEmailAndPassword(email, password);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassword(
      {required name, required email, required password}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        print("----- ?? true");

        return left(Failure(message: Constants.errorConnectionMessage));
      }
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
      if (!(await connectionChecker.isConnected)) {
        print("----- ? true");
        final session = authRemoteDataSource.userSession;
        if (session != null) {
          return right(UserEntity(
              name: "", email: session.user.email ?? "", id: session.user.id));
        }
        return left(Failure(message: Constants.errorConnectionMessage));
      }
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
