// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/constants/constant.dart';
import 'package:medical_blog_app/core/profile_local_datasource.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/update_profile_usecase.dart';
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
  final ProfileLocalDatasource profileLocalDatasource;

  AuthRepositoryImpl({
    required this.profileLocalDatasource,
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
          await profileLocalDatasource.saveUser(user);
          print("************** saving user info in local db");
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } on LocalStorageException catch (e) {
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
          await profileLocalDatasource.saveUser(userModel);

      return right(userModel);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } on LocalStorageException catch(e){
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUser() async {
    try {
      print("==> connection is ${await connectionChecker.isConnected}");
      if (!(await connectionChecker.isConnected)) {
        print("----- ? true");
        final session = authRemoteDataSource.userSession;
        print("==> session is ${session}");
        if (session != null) {
          final user = await profileLocalDatasource.getUser();
          print("---->>> user from local db: $user");
          return right(user);
          // return right(UserEntity(
          //     name:  "", email: session.user.email ?? "", id: session.user.id));
        }
        return left(Failure(message: Constants.errorConnectionMessage));
      }
      final user = await authRemoteDataSource.getUser();
      if (user != null){
      await profileLocalDatasource.saveUser(user);
        
      }
      if (user != null) {
        return right(user);
      } else {
        return right(null);
      }
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } on LocalStorageException catch(e){
      return left(Failure(message: e.message));
    }
  
  }
  
  @override
  Future<Either<Failure, void>> logOut() async {
    try {
       final res = await authRemoteDataSource.logOut();
      return right(res);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
    
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UpdateProfileParams params) {
    // first upload profile image
    return authRemoteDataSource.updateProfile(params);
  }
}
