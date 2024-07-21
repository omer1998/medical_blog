// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/providers/provider.dart';

import 'package:medical_blog_app/features/auth/data/models/user_model.dart';

final mainControllerProvider = Provider<MainController>((ref) {
  return MainController(ref: ref);
});
class MainController {
  Ref ref;
  MainController({
    required this.ref,
  });
  updateAppUser(UserModel? user){
    if (user != null ){
      ref.read(appUserProvider.notifier).state = user;
    }
  }
}
