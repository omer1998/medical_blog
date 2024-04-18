import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';

class SignInUseCase implements UseCase<UserEntity, SignInData> {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(SignInData params) async {
    return await authRepository.logInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class SignInData {
  final String email;
  final String password;

  SignInData({required this.email, required this.password});
}
