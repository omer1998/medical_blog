import 'package:medical_blog_app/core/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.id,
    super.followers_num,
    super.about,
    super.img_url,
    super.title,
    super.specialization,
    super.currentPosition,
    super.institution,
    super.expertise = const [],
    super.credentials = const [],
    super.isVerified = false,
    super.socialLinks = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    // cast map["social_links"] to list<string>

    // List<String> socialLs = map["social_links"] == null ? [] : map["social_links"].cast<String>() ?? [];
    //  Map<String, String> socialLinkMap = {};
    // if (socialLs.isNotEmpty) {
    //   socialLinkMap = {};
    //   /* for (var element in socialLs) {
    //     socialLinkMap.addAll({element: element});
    //   } */
    //   for (int i = 0; i< socialLs.length; i++) {
    //     if (i ==0 ){
    //       socialLinkMap["facebook"] = socialLs[i];
    //     }
    //     else if (i == 1){
    //       socialLinkMap["instagram"] = socialLs[i];
    //     }
        
    //   }
    // }
    return UserModel(
      id: map["id"] ?? '',
      name: map['name'] ?? "",
      email: map['email'] ?? '',
      about: map["about"] ?? "",
      img_url: map["img_url"] ?? "",
      followers_num: map["followers_num"] ?? 0,
      title: map['title'],
      specialization: map['specialization'],
      currentPosition: map['current_position'],
      institution: map['institution'],
      expertise:map["expertise"] is List ? List<String>.from(map['expertise'].map((e) => e.toString()).toList()) : [],
      credentials: map['credentials'] is List
        ? (map['credentials'] as List)
            .map((e) => Credential.fromJson(
              e is Map ? Map<String, dynamic>.from(e) : {}
            ))
            .toList()
        : [],
      isVerified: map['is_verified'] ?? false,
      socialLinks:map["social_links"] != null ? Map<String, dynamic>.from(map["social_links"]) : {} ,
    );
  }

  factory UserModel.fromJsonLocalDb(Map<String, dynamic> map) {
   
    return UserModel(
      id: map["id"] ?? '',
      name: map['name'] ?? "",
      email: map['email']  ?? '',
      about: map["about"]  ?? "",
      img_url: map["img_url"] ?? "",
      followers_num: map["followers_num"] ?? 0,
      title: map['title'],
      specialization: map['specialization'],
      currentPosition: map['current_position'],
      institution: map['institution'],
      expertise: List<String>.from(map['expertise']  ?? []),
      credentials: (map['credentials'] as List?)
          ?.map((e) => Credential.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      isVerified: map['is_verified'] ?? false,
      socialLinks:map['social_links'] ?? {} ,
    );
  }

  factory UserModel.fromJsonDatabase(Map<String, dynamic> map) {
    final metadata = map["user_metadata"] ?? {};
    return UserModel(
      id: map["id"] ?? '',
      name: metadata['name'] ?? "",
      email: metadata['email'] ?? '',
      about: metadata['about'] ?? '',
      img_url: metadata['img_url'] ?? '',
      followers_num: metadata['followers_num'] ?? 0,
      title: metadata['title'],
      specialization: metadata['specialization'],
      currentPosition: metadata['current_position'],
      institution: metadata['institution'],
      expertise: List<String>.from(metadata['expertise'] ?? []),
      credentials: (metadata['credentials'] as List?)
          ?.map((e) => Credential.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      isVerified: metadata['is_verified'] ?? false,
      socialLinks:metadata['social_links'] ?? {});
    
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "about": about,
      "img_url": img_url,
      "followers_num": followers_num,
      "title": title,
      "specialization": specialization,
      "current_position": currentPosition,
      "institution": institution,
      "expertise": expertise,
      "credentials":credentials == null ? [] : credentials!.map((e) => e.toJson()).toList(),
      "is_verified": isVerified,
      "social_links": socialLinks,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? about,
    String? img_url,
    int? followers_num,
    String? title,
    String? specialization,
    String? currentPosition,
    String? institution,
    List<String>? expertise,
    List<Credential>? credentials,
    bool? isVerified,
    Map<String, String>? socialLinks,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      about: about ?? this.about,
      img_url: img_url ?? this.img_url,
      followers_num: followers_num ?? this.followers_num,
      title: title ?? this.title,
      specialization: specialization ?? this.specialization,
      currentPosition: currentPosition ?? this.currentPosition,
      institution: institution ?? this.institution,
      expertise: expertise ?? this.expertise,
      credentials: credentials ?? this.credentials,
      isVerified: isVerified ?? this.isVerified,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}
