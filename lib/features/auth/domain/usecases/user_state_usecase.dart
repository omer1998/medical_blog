import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';

class UserStateUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository authRepository;

  UserStateUseCase({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return authRepository.getUser();
  }
}

class NoParams {}
