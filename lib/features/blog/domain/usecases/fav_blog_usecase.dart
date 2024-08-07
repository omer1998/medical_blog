import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/features/blog/domain/repositories/blog_repository.dart';

class FavBlogUseCase implements UseCase<void, FavParams>{
  final BlogRepository blogRepository;
  FavBlogUseCase({required this.blogRepository});
  @override
  Future<Either<Failure, void>> call(FavParams params) {
    // TODO: implement call
    return blogRepository.favBlog(blogId: params.blogId, userId: params.userId);
  }

}

class FavParams {
  final String blogId;
  final String userId;
  FavParams(this.blogId, this.userId);

}