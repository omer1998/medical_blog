import 'package:medical_blog_app/features/profile/domain/entities/professional_profile.dart';

class ProfessionalProfileModel extends ProfessionalProfile {
  const ProfessionalProfileModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.title,
    required super.specialization,
    required super.credentials,
    required super.currentPosition,
    required super.institution,
    required super.bio,
    required super.expertise,
    required super.profileImage,
    required super.isVerified,
    required super.contactInfo,
  });

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      title: json['title'] as String,
      specialization: json['specialization'] as String,
      credentials: (json['credentials'] as List)
          .map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPosition: json['current_position'] as String,
      institution: json['institution'] as String,
      bio: json['bio'] as String,
      expertise: List<String>.from(json['expertise'] as List),
      profileImage: json['profile_image'] as String,
      isVerified: json['is_verified'] as bool,
      contactInfo: ContactInfoModel.fromJson(json['contact_info'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'title': title,
      'specialization': specialization,
      'credentials': credentials.map((e) => (e as CredentialModel).toJson()).toList(),
      'current_position': currentPosition,
      'institution': institution,
      'bio': bio,
      'expertise': expertise,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'contact_info': (contactInfo as ContactInfoModel).toJson(),
    };
  }
}

class CredentialModel extends Credential {
  const CredentialModel({
    required super.type,
    required super.title,
    required super.institution,
    required super.year,
    required super.isVerified,
    super.verificationId,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return CredentialModel(
      type: json['type'] as String,
      title: json['title'] as String,
      institution: json['institution'] as String,
      year: json['year'] as String,
      isVerified: json['is_verified'] as bool,
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
}

class ContactInfoModel extends ContactInfo {
  const ContactInfoModel({
    required super.email,
    super.phone,
    required super.socialLinks,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'] as String,
      phone: json['phone'] as String?,
      socialLinks: Map<String, String>.from(json['social_links'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'social_links': socialLinks,
    };
  }
}
