import 'package:equatable/equatable.dart';

class ProfessionalProfile extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String title;
  final String specialization;
  final List<Credential> credentials;
  final String currentPosition;
  final String institution;
  final String bio;
  final List<String> expertise;
  final String profileImage;
  final bool isVerified;
  final ContactInfo contactInfo;

  const ProfessionalProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.title,
    required this.specialization,
    required this.credentials,
    required this.currentPosition,
    required this.institution,
    required this.bio,
    required this.expertise,
    required this.profileImage,
    required this.isVerified,
    required this.contactInfo,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        title,
        specialization,
        credentials,
        currentPosition,
        institution,
        bio,
        expertise,
        profileImage,
        isVerified,
        contactInfo,
      ];
}

class Credential extends Equatable {
  final String type;
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
    required this.isVerified,
    this.verificationId,
  });

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

class ContactInfo extends Equatable {
  final String email;
  final String? phone;
  final Map<String, String> socialLinks;

  const ContactInfo({
    required this.email,
    this.phone,
    required this.socialLinks,
  });

  @override
  List<Object?> get props => [email, phone, socialLinks];
}
