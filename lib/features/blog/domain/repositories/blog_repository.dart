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
  // Future<Either<Failure,void>> deleteBlog({required String blogId});
  // Future<Either<Failure, BlogEntity>> updateBlog({required String blogId});
  Future<Either<Failure,void>> favBlog({required String blogId, required String userId});

}
