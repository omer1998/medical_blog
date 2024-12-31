// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String email;
  final String id;
  final String? img_url;
  final String? about;
  final int? followers_num;
  
  // Professional Information
  final String? title;  // Dr., Prof., etc.
  final String? specialization;
  final String? currentPosition;
  final String? institution;
  final List<String>? expertise;
  final List<Credential>? credentials;
  final bool isVerified;
  final Map<String, dynamic>? socialLinks;

  const UserEntity({
    required this.name,
    required this.email,
    required this.id,
    this.img_url,
    this.about,
     this.followers_num,
    this.title,
    this.specialization,
    this.currentPosition,
    this.institution,
    this.expertise = const [],
    this.credentials = const [],
    this.isVerified = false,
    this.socialLinks = const {},
  });

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, img_url: $img_url, about: $about, title: $title, specialization: $specialization)';
  }
  
  @override
  List<Object?> get props => [
        id,
        name,
        email,
        img_url,
        about,
        followers_num,
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
