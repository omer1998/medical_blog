import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';

final followUtilityProvider = Provider<FollowUtility>((ref) {
  return FollowUtility(ref: ref);
});


class FollowUtility {
  final Ref ref;

  FollowUtility({required this.ref});
//  add unique constraint for two columns in db
  Future<bool> addFollow(String followerId, String followedId) async {
    try {
      if( await isConnected()){
    final result =    await ref.read(supabaseClientProvider).from("followers").insert({
          "follower_id": followerId,
          "followed_id": followedId,
        }).select();
        print("result: $result");
      return true;
      } else {
        throw ServerException("No Internet Connection");
      }
    } catch (e) {
      throw ServerException("Error following: ${e.toString()}");
    }

  }
  Future<bool> isFollowed(String followerId, String followedId) async {
    print(await isConnected());
    try {
      if( await isConnected()){
        final isFollowed = await ref.read(supabaseClientProvider).from("followers").select().match({
          "follower_id": followerId,
          "followed_id": followedId,
        });
        print("is followed : ${isFollowed}");
      return isFollowed.isNotEmpty ? true : false;
      } else {
        throw ServerException("No Internet Connection");
      }
    } on ServerException  {
      rethrow;
    }
    catch (e) {
      throw ServerException("Error Explore Follow: ${e.toString()}");
    }
  }

  removeFollow(String followerId, String followedId) async{
    try {
      if( await isConnected()){
        print("remove follow");
        print({
          "follower_id": followerId,
          "followed_id": followedId,

        });
          await ref.read(supabaseClientProvider).from("followers").delete().match(
            {
              "follower_id": followerId,
              "followed_id": followedId,
            }
          );
      
      } else {
        throw ServerException("No Internet Connection");
      }
    } catch (e) {
      throw ServerException("Error Removing Follow : ${e.toString()}");
    }
  }
  getFollowers(String followedId) {}
  getFollowersNum(String followedId) {}
}
