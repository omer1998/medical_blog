import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';

class LogOutUsecase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogOutUsecase({required this.authRepository});
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return authRepository.logOut();
  }
  
}
