import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/providers/provider.dart';

final rivBlogRepositoryProvider = Provider<RivBlogRepository>((ref) {
  return RivBlogRepository(ref: ref);
});

final getFavoriteBlogsProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, id) async {
  return ref.read(rivBlogRepositoryProvider).getFavoriteBlog(id) ;
});
class RivBlogRepository {
  final Ref ref;

  RivBlogRepository({required this.ref});
  Future<List<String>> getFavoriteBlog(String userId)async{
    try {
      final list = await ref.read(supabaseClientProvider).from("fav_blogs").select("blog_id").eq("user_id", userId);
      List<String> blogIds = list.map<String>((e)=>e["blog_id"]).toList();
      print("list");
      print(list);
    return blogIds;
   
    } catch (e) {
      rethrow; 
    }
  
  }
}
// import 'package:riverpod/riverpod.dart';