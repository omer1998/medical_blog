import 'package:equatable/equatable.dart';

enum VerificationStatus {
  pending,
  verified,
  rejected
}

class CredentialModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String institution;
  
  final String year;
  final String type; // degree, certification, license, etc.
  final String? documentUrl;
  final VerificationStatus status;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  const CredentialModel({
    
    required this.id,
    required this.userId,
    required this.title,
    required this.institution,
    required this.year,
    required this.type,
    this.documentUrl,
    this.status = VerificationStatus.pending,
    this.verifiedAt,
    this.verifiedBy,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return CredentialModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      institution: json['institution'] as String,
      year: json['year'] as String,
      type: json['type'] as String,
      documentUrl: json['documentUrl'] as String?,
      status: VerificationStatus.values.firstWhere(
        (e) => e.toString() == 'VerificationStatus.${json['status']}',
        orElse: () => VerificationStatus.pending,
      ),
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'] as String)
          : null,
      verifiedBy: json['verifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'institution': institution,
      'year': year,
      'type': type,
      'document_url': documentUrl,
      'status': status.toString().split('.').last,
      'verified_at': verifiedAt?.toIso8601String(),
      'verified_by': verifiedBy,
    };
  }

  CredentialModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? institution,
    String? year,
    String? type,
    String? documentUrl,
    VerificationStatus? status,
    DateTime? verifiedAt,
    String? verifiedBy,
  }) {
    return CredentialModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      institution: institution ?? this.institution,
      year: year ?? this.year,
      type: type ?? this.type,
      documentUrl: documentUrl ?? this.documentUrl,
      status: status ?? this.status,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        institution,
        year,
        type,
        documentUrl,
        status,
        verifiedAt,
        verifiedBy,
      ];
}
