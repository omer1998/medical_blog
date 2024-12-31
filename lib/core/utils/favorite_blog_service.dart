
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';

final blogFavoriteServiceProvider = Provider<FavoriteBlogService>((ref) {
  return FavoriteBlogService(ref: ref);
});

class FavoriteBlogService{
  final Ref ref;

  FavoriteBlogService({required this.ref});

  Future<bool> isFavorite(String userId, String blogId) async {
    try {
      if (await isConnected()){
      final response = await ref.read(supabaseClientProvider)
        .from('fav_blogs')
        .select()
        .match({'user_id': userId, 'blog_id': blogId});
        print("response: $response");
    if (response.isEmpty){
      return false;
    } else {
      return true;
    }
    }else {
      throw Exception("No Internet Connection");
    }
    
      
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavoriteBlog(String userId, String blogId)async {
    try {
      if (await isConnected()){
print(blogId);
      print(userId);
      
      await ref.read(supabaseClientProvider).from("fav_blogs").insert({
      "user_id": userId,
      "blog_id": blogId,
    
    });
      }else {
        throw Exception("No Internet Connection");
      }
       
    return ;

    } catch (e) {
      rethrow;
    }
  }
  Future<List<String>> getFavoriteBlogs(String userId)async {
    try {

        final result=  await ref.read(supabaseClientProvider).from("fav_blogs").select("blog_id").eq("user_id", userId);
        final list = result.map<String>((e)=> e["blog_id"]).toList();
        return list;
    } catch (e) {
      rethrow;
      }
  }
 Future<void> removeFavoriteBlog( String userId, String blogId) async{
  print(userId);
  print(blogId);
try {
if (await isConnected()){
    await ref.read(supabaseClientProvider).from("fav_blogs").delete().eq("user_id", userId).eq("blog_id", blogId);
 return;

}else{
throw Exception("No Internet Connection");
}

    // .match({
    //   "user_id": userId,
    //   "blog_id": blogId,
    // });
    // .eq("user_id", userId);
} catch (e) {
  rethrow;
}
  }

  //ref.watch(favoriteBlogProvider)
}