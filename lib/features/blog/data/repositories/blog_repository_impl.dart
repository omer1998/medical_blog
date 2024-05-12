// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

import 'package:medical_blog_app/core/constants/constant.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';
import 'package:medical_blog_app/features/blog/data/datasources/local_data_source.dart';
import 'package:medical_blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/domain/repositories/blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final ConnectionChecker connectionChecker;
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;

  BlogRepositoryImpl({
    required this.connectionChecker,
    required this.blogRemoteDataSource,
    required this.blogLocalDataSource,
  });

  @override
  Future<Either<Failure, BlogEntity>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String authorId,
      required List<String> topics}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(message: Constants.errorConnectionMessage));
      }
      final blog = BlogModel(
        id: const Uuid().v1(),
        title: title,
        content: content,
        authorId: authorId,
        publishedDate: DateTime.now(),
        topics: topics,
        imageUrl: "",
      );
      final imagUrl = await blogRemoteDataSource.uploadImage(blog, image);

      final uploadedBlog = await blogRemoteDataSource
          .uploadBlog(blog.copyWith(imageUrl: imagUrl));
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> fetchBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        // fetch blogs from local datasource
        // if (blogLocalDataSource.loadBlogs().isNotEmpty) {
        //   return right(blogLocalDataSource.loadBlogs());
        // }
        // return left(Failure(message: Constants.errorConnectionMessage));
        print("blogs ---> ");
        print(blogLocalDataSource.loadBlogs());
        return right(blogLocalDataSource.loadBlogs());
      }
      final blogs = await blogRemoteDataSource.fetchAllBlogs();
      // we need to save blogs in hive datastorage
      blogLocalDataSource.uploadBlogs(blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
