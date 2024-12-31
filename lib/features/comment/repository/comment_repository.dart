import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';
import 'package:medical_blog_app/features/comment/models/comment_model.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(ref: ref);
});

class CommentRepository {
  final Ref ref;

  CommentRepository({ required this.ref});
  Future<List<Comment>> getComments(String blogId) async {
    try {
      if (await isConnected()){
         print("blog id: $blogId");
    
      final response = await ref.read(supabaseClientProvider).from("comments").select(" * ,profiles(name, img_url, id)").eq("blog_id", blogId);
      // print("comment response: $response");
      final comments = response.map((e) => Comment.fromMap(e)).toList();
      print("comments: $comments");
      return comments;
      
      }
      else {
        throw Exception("No internet Connection !!");
      }
     
    } catch (e) {
      throw Exception("Error getting comments: $e");
    }
  

  }

  Future<void> addComment({required String content,required String blogId,required userId,  String? parentId }) async {
    try {
      if (await isConnected()){
        await ref.read(supabaseClientProvider).from("comments").insert({
        "content": content,
        "blog_id": blogId,
        "parent_id": parentId,
        "user_id": userId
      }
      ) ;
      }
      else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      throw Exception("Error Inserting Comment");
    }
  }
}