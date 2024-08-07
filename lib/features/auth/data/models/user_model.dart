import 'package:medical_blog_app/core/entities/user.dart';

class UserModel extends UserEntity {
  UserModel(
      {super.about,
      super.img_url,
      required super.name,
      required email,
      required id})
      : super(email: email, id: id);

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      about: map["about"] ?? "",
      img_url: map["img_url"] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? '',
      id: map["id"] ?? '',
    );
  }

  factory UserModel.fromJsonDatabase(Map<String, dynamic> map) {
    return UserModel(
      name: map["user_metadata"]['name'] ?? "",
      email: map["user_metadata"]['email'] ?? '',
      about: map["user_metadata"]['about'] ?? '',
      img_url: map["user_metadata"]['img_url'] ?? '',
      id: map["id"] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "id": id,
      "about": about,
      "img_url": img_url,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? about,
    String? img_url,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      about: about ?? this.about,
      img_url: img_url ?? this.img_url,
    );
  }
}
