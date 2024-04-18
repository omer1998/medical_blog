import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/usecase/usecase.dart';

class SignUpUseCase implements UseCase<UserEntity, SignUpData> {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(SignUpData params) async {
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class SignUpData {
  final String name;
  final String email;
  final String password;

  SignUpData({required this.name, required this.email, required this.password});
}
