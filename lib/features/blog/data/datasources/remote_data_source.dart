import 'dart:io';

import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage(BlogModel blog, File image);
  Future<List<BlogModel>> fetchAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      print("insert blog to database");
      print(blog.toString());
      final insertedBlog =
          await supabaseClient.from("blogs").insert(blog.toMap()).select();
      return BlogModel.fromMap(insertedBlog.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(BlogModel blog, File image) async {
    try {
      await supabaseClient.storage.from("blog_image").upload(blog.id, image);
      return supabaseClient.storage.from("blog_image").getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> fetchAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from("blogs").select('* , profiles(id, name)');
      print("----> new blogs");
      print(blogs);
      return blogs.map((blog) => BlogModel.fromMap(blog)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
