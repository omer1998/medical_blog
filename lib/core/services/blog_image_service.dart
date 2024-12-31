import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class BlogImageService {
  static Future<String> uploadBlogImage(
      {required String urlPath, required String imagePath}) async {
    // put try catch
    // perform rollback
    final supabaseStorage = Supabase.instance.client.storage;
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${imagePath.split('/').last}";
    await supabaseStorage
        .from('blog_image')
        .upload("${urlPath}/${fileName}", File(imagePath));
    return supabaseStorage
        .from('blog_image')
        .getPublicUrl("${urlPath}/$fileName");
  }

  static removeBlogImages({required List<String> imageUrls}) async {
    try {
          final supabaseStorage = Supabase.instance.client.storage;
         
    final response = await supabaseStorage.from("blog_image").remove(['07696020-e46c-1077-91ba-3d58f6874b34.jpg']);
    print(response);
    print("removing images");

    

      
    } catch (e) {
      return "Error removing images ${e.toString()}";
    }
  }
}
