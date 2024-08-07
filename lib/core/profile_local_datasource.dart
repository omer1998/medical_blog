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
      dynamic user = profileBox.get("user");
      if (user != null) {
        user = user.cast<String, dynamic>();
        profileBox.close();
        final userModel = UserModel.fromJson(user);
        return userModel;
      } else {
        throw LocalStorageException(message: "Error; user not found");
      }
    } catch (e) {
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
