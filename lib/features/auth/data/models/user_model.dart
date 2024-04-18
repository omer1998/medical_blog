import 'package:medical_blog_app/core/entities/user.dart';

class UserModel extends UserEntity {
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      email: map['email'] ?? '',
      id: map["id"] ?? '',
    );
  }

  UserModel({required super.name, required email, required id})
      : super(email: email, id: id);

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }
}
