import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';

final profileLocalDatasourceProvider = Provider<ProfileLocalDatasource>((ref) {
  return ProfileLocalDatasource();
});

class ProfileLocalDatasource {
  Future<UserModel> getUser() async {
    try {
      final profileBox = await Hive.openBox("profileBox");
      final user = profileBox.get("user");
      print("Raw user type: ${user.runtimeType}");
      print("Raw user content: $user");
      if (user != null) {
        Map<String, dynamic> userMap = {};
        user.forEach((key, value) {
          userMap[key.toString()] = value;
        });
       
        print("user after cast ${userMap.runtimeType}");
        print("user is ${userMap}");
        profileBox.close();

        final userModel = UserModel.fromJson(userMap);
        return userModel;
      } else {
        throw LocalStorageException(message: "Error; user not found");
      }
    } catch (e) {
      print("error in getting user from local db ${e.toString()}");
      throw LocalStorageException(
          message: "Error geting user from local DB ${e.toString()}");
    }
  }

  Future<bool> saveUser(UserModel user) async {
    try {
      final profileBox = await Hive.openBox("profileBox");
      profileBox.put("user", user.toMap());
      profileBox.close();

      return true;
    } catch (e) {
      throw LocalStorageException(
          message: "Error saving user locally ${e.toString()}");
    }
  }
}
