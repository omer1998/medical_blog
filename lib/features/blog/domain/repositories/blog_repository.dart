import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, BlogEntity>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String authorId,
      required List<String> topics});

  Future<Either<Failure, List<BlogEntity>>> fetchBlogs();
}
