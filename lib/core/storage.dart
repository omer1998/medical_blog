import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// final storageProvider = Provider<Storage>((ref) {
//   return Storage(ref: ref) ;
// });

final storageProvider = Provider<Storage>((ref) {
  return Storage(ref: ref);
});

// final saveProfileImgProvider = FutureProvider.family<String, Map<String,dynamic>>((ref, data) async {
//  return ref.read(storageProvider).saveProfileImg(data["img"], data["userId"]);
// });
class Storage {
  final Ref ref;

  Storage({required this.ref});
  Future<String>saveProfileImg(File img, String userId) async {
    try {
      // state = true;
         final result = await ref.read(supabaseClientProvider).storage.from("avatars").upload(userId, img, fileOptions: const FileOptions(upsert: true),);
        final img_url = await ref.read(supabaseClientProvider).storage.from("avatars").getPublicUrl(userId);
        

        // state= false;
        return img_url;
    } catch (e) {
      rethrow;
    }
  }

}