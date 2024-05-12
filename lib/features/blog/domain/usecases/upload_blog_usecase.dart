import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/usecase/usecase.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/domain/repositories/blog_repository.dart';

class UploadBlogUseCase implements UseCase<BlogEntity, BlogData> {
  final BlogRepository blogRepository;

  UploadBlogUseCase({required this.blogRepository});
  @override
  Future<Either<Failure, BlogEntity>> call(BlogData params) {
    return blogRepository.uploadBlog(
        image: params.image,
        title: params.title,
        content: params.content,
        authorId: params.authorId,
        topics: params.topics);
  }
}

class BlogData {
  final String title;
  final String content;
  final File image;
  final String authorId;
  final List<String> topics;

  BlogData(
      {required this.title,
      required this.content,
      required this.image,
      required this.authorId,
      required this.topics});
}
