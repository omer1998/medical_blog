import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage(BlogModel blog, File image);
  Future<List<BlogModel>> fetchAllBlogs();
  Future<void> favBlog(String userId, String blogId);
}


class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({ required this.supabaseClient});
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      print(blog.toMapInsert());
      final insertedBlog =
          await supabaseClient.from("blogs").insert(blog.toMapInsert()).select('* , profiles(id, name)');
          print("this is the blog --> ${insertedBlog.first}");
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
  
  @override
  Future<void> favBlog(String userId, String blogId) async{
    try {
      await supabaseClient.from("fav_blogs").insert({
      "user_id": userId,
      "blog_id": blogId,
    
    }); 
    return ;

    } catch (e) {
      rethrow;
    }
  }
}
