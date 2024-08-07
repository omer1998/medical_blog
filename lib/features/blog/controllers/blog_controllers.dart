
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/utils/favorite_blog_service.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';

final blogControllerProvider = Provider<BlogController>((ref) {
  return BlogController(ref: ref);
});

final isFavoriteProvider =
    FutureProvider.autoDispose.family<bool, BlogParams>((ref, data) async{
  final cont = ref.read(blogControllerProvider);
  bool isFav = await cont.isFavorite(data.params["userId"], data.params["blogId"]);
  return isFav;
});

// final blogControllerProvider = StateNotifierProvider.family<BlogController, AsyncValue<bool>, Map<String, dynamic>>((ref, data) {
//   return BlogController(userId: data["userId"], blogId: data["blofId"], ref: ref);
// });
// final getFavBlogsProvider = FutureProvider.family<List<String>,String>((ref, userId) async {
//   return BlogController(ref: ref).getAllFavoriteBlogs(userId);
// });
class BlogController {
  final Ref ref;

  BlogController({required this.ref});

 isFavorite(String userId, String blogId) async {
    try {
      print("userId and blogId");
      print(userId);
      print(blogId);
      bool isFavorite = await ref
          .read(blogFavoriteServiceProvider)
          .isFavorite(userId, blogId);
      print("isFavorite");
      print( isFavorite);
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
      ref.refresh(isFavoriteProvider.call(BlogParams({"userId": userId, "blogId": blogId})));

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
      ref.refresh(isFavoriteProvider.call(BlogParams({"userId": userId, "blogId": blogId})));
      showSnackBar(context, "Success");

      print("removed list");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
