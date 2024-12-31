import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/utils/favorite_blog_service.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/blog/data/models/blog_model.dart';
import 'package:medical_blog_app/features/blog/domain/entities/blog_entity.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/add_new_blog_page_section.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:medical_blog_app/features/main/main_page.dart';
import 'package:medical_blog_app/features/profile/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// final blogControllerProvider = Provider<BlogController>((ref) {
//   return BlogController(ref: ref);
// });
final allAvailableBlogTagsProvider = StateProvider<List<String>>((ref) {
  return [];
});
final selectedBlogTagsProvider = StateProvider<List<String>>((ref) {
  return [];
});
final blogControllerProvider =
    StateNotifierProvider<BlogController, bool>((ref) {
  return BlogController(ref: ref);
});

final isFavoriteProvider =
    FutureProvider.autoDispose.family<bool, BlogParams>((ref, data) async {
  final cont = ref.read(blogControllerProvider.notifier);
  bool isFav =
      await cont.isFavorite(data.params["userId"], data.params["blogId"]);
  return isFav;
});

// final blogControllerProvider = StateNotifierProvider.family<BlogController, AsyncValue<bool>, Map<String, dynamic>>((ref, data) {
//   return BlogController(userId: data["userId"], blogId: data["blofId"], ref: ref);
// });
// final getFavBlogsProvider = FutureProvider.family<List<String>,String>((ref, userId) async {
//   return BlogController(ref: ref).getAllFavoriteBlogs(userId);
// });
class BlogController extends StateNotifier<bool> {
  final Ref ref;

  BlogController({required this.ref}) : super(false);

  isFavorite(String userId, String blogId) async {
    try {
      print("userId and blogId");
      print(userId);
      print(blogId);
      bool isFavorite = await ref
          .read(blogFavoriteServiceProvider)
          .isFavorite(userId, blogId);
      print("isFavorite");
      print(isFavorite);
      return isFavorite;
    } catch (e) {
      rethrow;
    }
  }

  getAllFavoriteBlogs(String userId) async {
    try {
      await ref.read(blogFavoriteServiceProvider).getFavoriteBlogs(userId);
    } catch (e) {
      rethrow;
    }
  }

  addFavBlog(BuildContext context, String blogId, String userId) async {
    try {
      await ref
          .read(blogFavoriteServiceProvider)
          .addFavoriteBlog(blogId, userId);
      showSnackBar(context, "Success");
      // ref.refresh(getFavBlogsProvider.call(userId));
      ref.refresh(isFavoriteProvider
          .call(BlogParams({"userId": userId, "blogId": blogId})));

      print("added list");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  removeFavBlog(BuildContext context, String blogId, String userId) async {
    try {
      await ref
          .read(blogFavoriteServiceProvider)
          .removeFavoriteBlog(blogId, userId);
      ref.refresh(isFavoriteProvider
          .call(BlogParams({"userId": userId, "blogId": blogId})));
      showSnackBar(context, "Success");

      print("removed list");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String> upLoadBlogImage(
      String blogId, String index, File image) async {
    try {
      await ref
          .read(supabaseClientProvider)
          .storage
          .from("blog_image")
          .upload("${blogId}/$index", image);
      return ref
          .read(supabaseClientProvider)
          .storage
          .from("blog_image")
          .getPublicUrl("${blogId}/$index");
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  submitBlogPost(BlogModel blog) async {
    try {
      await ref
          .read(supabaseClientProvider)
          .from("blogs")
          .insert(blog.toMapInsert());
    } catch (e) {
      rethrow;
    }
  }

  uploadBlog(List<Section> sections, String blogId, BuildContext context,
      {required List<String> selectedTags,
      required title,
      required content,
      required userId,
      required blogImg}) async {
    // upload images
    try {
      state = true;
      List<Section> newSection = [];
      for (var i = 0; i < sections.length; i++) {
        if (sections[i].imagesFile.isNotEmpty) {
          for (var j = 0; j < sections[i].imagesFile.length; j++) {
            final imageUrl = await upLoadBlogImage(blogId,
                "${i.toString()} ${j.toString()}", sections[i].imagesFile[j]);
            sections[i].images.add(imageUrl);
          }
        }
      }

      final blogImageUrl = await upLoadBlogImage(blogId, 'blogImg', blogImg);
      String contentJson =
          jsonEncode(sections.map((section) => section.toJson()).toList());

      print("sectioJson: ${sections.map((s) => s.toJson())}");
      await submitBlogPost(BlogModel(
          id: blogId,
          title: title,
          content: content,
          authorId: userId,
          publishedDate: DateTime.now(),
          topics: selectedTags,
          imageUrl: blogImageUrl,
          contentJson: contentJson));
      state = false;
      showSnackBar(context, "Successfully uploaded blog");
      BlocProvider.of<BlogBloc>(context).add(BlogFetchBlogsEvent());
      Navigator.of(context).pop();

      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> MainPage()), (route)=> false);
      // GoRouter.of(context).goNamed("main");
    } on ServerException catch (e) {
      state = false;

      await ref
          .read(supabaseClientProvider)
          .storage
          .from("blog_image")
          .remove([blogId]);

      print(e.message);
    } catch (e) {
      state = false;

      await ref
          .read(supabaseClientProvider)
          .storage
          .from("blog_image")
          .remove([blogId]);

      print(e.toString());
    }
  }
}
