import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;
  
  // Professional Information
  final String? title;  // Dr., Prof., etc.
  final String? specialization;
  final String? currentPosition;
  final String? institution;
  final List<String> expertise;
  final List<Credential> credentials;
  final bool isVerified;
  final Map<String, String> socialLinks;

  const User({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
    this.title,
    this.specialization,
    this.currentPosition,
    this.institution,
    this.expertise = const [],
    this.credentials = const [],
    this.isVerified = false,
    this.socialLinks = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      imagePath: json['image_path'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      about: json['about'] as String,
      isDarkMode: json['is_dark_mode'] as bool? ?? false,
      title: json['title'] as String?,
      specialization: json['specialization'] as String?,
      currentPosition: json['current_position'] as String?,
      institution: json['institution'] as String?,
      expertise: List<String>.from(json['expertise'] ?? []),
      credentials: (json['credentials'] as List?)
          ?.map((e) => Credential.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      isVerified: json['is_verified'] as bool? ?? false,
      socialLinks: Map<String, String>.from(json['social_links'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'name': name,
      'email': email,
      'about': about,
      'is_dark_mode': isDarkMode,
      'title': title,
      'specialization': specialization,
      'current_position': currentPosition,
      'institution': institution,
      'expertise': expertise,
      'credentials': credentials.map((e) => e.toJson()).toList(),
      'is_verified': isVerified,
      'social_links': socialLinks,
    };
  }

  User copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
    String? title,
    String? specialization,
    String? currentPosition,
    String? institution,
    List<String>? expertise,
    List<Credential>? credentials,
    bool? isVerified,
    Map<String, String>? socialLinks,
  }) {
    return User(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      isDarkMode: isDarkMode ?? this.isDarkMode,
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

  @override
  List<Object?> get props => [
        id,
        imagePath,
        name,
        email,
        about,
        isDarkMode,
        title,
        specialization,
        currentPosition,
        institution,
        expertise,
        credentials,
        isVerified,
        socialLinks,
      ];
}

class Credential extends Equatable {
  final String type;  // 'education', 'certification', 'license'
  final String title;
  final String institution;
  final String year;
  final bool isVerified;
  final String? verificationId;

  const Credential({
    required this.type,
    required this.title,
    required this.institution,
    required this.year,
    this.isVerified = false,
    this.verificationId,
  });

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      type: json['type'] as String,
      title: json['title'] as String,
      institution: json['institution'] as String,
      year: json['year'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      verificationId: json['verification_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'institution': institution,
      'year': year,
      'is_verified': isVerified,
      'verification_id': verificationId,
    };
  }

  Credential copyWith({
    String? type,
    String? title,
    String? institution,
    String? year,
    bool? isVerified,
    String? verificationId,
  }) {
    return Credential(
      type: type ?? this.type,
      title: title ?? this.title,
      institution: institution ?? this.institution,
      year: year ?? this.year,
      isVerified: isVerified ?? this.isVerified,
      verificationId: verificationId ?? this.verificationId,
    );
  }

  @override
  List<Object?> get props => [
        type,
        title,
        institution,
        year,
        isVerified,
        verificationId,
      ];
}
