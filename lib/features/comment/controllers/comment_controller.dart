import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/comment/models/comment_model.dart';
import 'package:medical_blog_app/features/comment/repository/comment_repository.dart';

final commentControllerProvider = Provider<CommentController>((ref) {
  return CommentController(ref: ref);
});

final getCommentsProvider = FutureProvider.autoDispose
    .family<List<Comment>, String>((ref, blogId) async {
  final comments =
      await ref.watch(commentControllerProvider).getComments(blogId);
  return comments;
});

class CommentController {
  final Ref ref;

  CommentController({required this.ref});

  addCommment(
      {required BuildContext context,
      required String content,
      required String blogId,
      required String userId,
      String? parentId}) async {
    try {
      await ref.read(commentRepositoryProvider).addComment(
          content: content, blogId: blogId, userId: userId, parentId: parentId);
          // ref.refresh(getCommentsProvider.call(blogId));
          showSnackBar(context, "Comment added successfully");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  getComments(String blogId) async {
    try {
      final List<Comment> comments =
          await ref.read(commentRepositoryProvider).getComments(blogId);
      return comments;
    } catch (e) {
      rethrow;
    }
  }
}
