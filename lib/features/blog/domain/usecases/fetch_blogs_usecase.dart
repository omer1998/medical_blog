import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/domain/repositories/blog_repository.dart';

class FetchBlogsUseCase implements UseCase<List<BlogEntity>, NoParams> {
  final BlogRepository blogRepository;

  FetchBlogsUseCase({required this.blogRepository});
  @override
  Future<Either<Failure, List<BlogEntity>>> call(NoParams params) {
    return blogRepository.fetchBlogs();
  }
}
