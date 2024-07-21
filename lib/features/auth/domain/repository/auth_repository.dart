import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/entities/user.dart';

import '../../../../core/error/failures.dart';

abstract interface class AuthRepository {
  // note in the success state we will not return a string, we will return user entity object
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword(
      {required name, required email, required password});

  Future<Either<Failure, UserEntity>> logInWithEmailPassword({
    required email,
    required password,
  });

  Future<Either<Failure, UserEntity?>> getUser();

  Future<Either<Failure, void>> logOut();
}
