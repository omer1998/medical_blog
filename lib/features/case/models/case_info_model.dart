// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CaseInfo {
  final String demographic_data;
  final String cheif_complain;
  final String illness_hx;
  final String review_hx;
  final String meds_hx;
  final String pmh;
  final String psh;
  final String family_hx;
  final String physical_exam;
  final String vital_signs;
  final String followup_notes;
  final String ddx;
  final String management_plan;
  CaseInfo({
    required this.demographic_data,
    required this.cheif_complain,
    required this.illness_hx,
    required this.review_hx,
    required this.meds_hx,
    required this.pmh,
    required this.psh,
    required this.family_hx,
    required this.physical_exam,
    required this.vital_signs,
    required this.followup_notes,
    required this.ddx,
    required this.management_plan,
  });


  CaseInfo copyWith({
    String? demographic_data,
    String? cheif_complain,
    String? illness_hx,
    String? review_hx,
    String? meds_hx,
    String? pmh,
    String? psh,
    String? family_hx,
    String? physical_exam,
    String? vital_signs,
    String? followup_notes,
    String? ddx,
    String? management_plan,
  }) {
    return CaseInfo(
      demographic_data: demographic_data ?? this.demographic_data,
      cheif_complain: cheif_complain ?? this.cheif_complain,
      illness_hx: illness_hx ?? this.illness_hx,
      review_hx: review_hx ?? this.review_hx,
      meds_hx: meds_hx ?? this.meds_hx,
      pmh: pmh ?? this.pmh,
      psh: psh ?? this.psh,
      family_hx: family_hx ?? this.family_hx,
      physical_exam: physical_exam ?? this.physical_exam,
      vital_signs: vital_signs ?? this.vital_signs,
      followup_notes: followup_notes ?? this.followup_notes,
      ddx: ddx ?? this.ddx,
      management_plan: management_plan ?? this.management_plan,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'demographic_data': demographic_data,
      'cheif_complain': cheif_complain,
      'illness_hx': illness_hx,
      'review_hx': review_hx,
      'meds_hx': meds_hx,
      'pmh': pmh,
      'psh': psh,
      'family_hx': family_hx,
      'physical_exam': physical_exam,
      'vital_signs': vital_signs,
      'followup_notes': followup_notes,
      'ddx': ddx,
      'management_plan': management_plan,
    };
  }

  factory CaseInfo.fromMap(Map<String, dynamic> map) {
    return CaseInfo(
      demographic_data: map['demographic_data'] as String,
      cheif_complain: map['cheif_complain'] as String,
      illness_hx: map['illness_hx'] as String,
      review_hx: map['review_hx'] as String,
      meds_hx: map['meds_hx'] as String,
      pmh: map['pmh'] as String,
      psh: map['psh'] as String,
      family_hx: map['family_hx'] as String,
      physical_exam: map['physical_exam'] as String,
      vital_signs: map['vital_signs'] as String,
      followup_notes: map['followup_notes'] as String,
      ddx: map['ddx'] as String,
      management_plan: map['management_plan'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CaseInfo.fromJson(String source) => CaseInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CaseInfo(demographic_data: $demographic_data, cheif_complain: $cheif_complain, illness_hx: $illness_hx, review_hx: $review_hx, meds_hx: $meds_hx, pmh: $pmh, psh: $psh, family_hx: $family_hx, physical_exam: $physical_exam, vital_signs: $vital_signs, followup_notes: $followup_notes, ddx: $ddx, management_plan: $management_plan)';
  }

  @override
  bool operator ==(covariant CaseInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.demographic_data == demographic_data &&
      other.cheif_complain == cheif_complain &&
      other.illness_hx == illness_hx &&
      other.review_hx == review_hx &&
      other.meds_hx == meds_hx &&
      other.pmh == pmh &&
      other.psh == psh &&
      other.family_hx == family_hx &&
      other.physical_exam == physical_exam &&
      other.vital_signs == vital_signs &&
      other.followup_notes == followup_notes &&
      other.ddx == ddx &&
      other.management_plan == management_plan;
  }

  @override
  int get hashCode {
    return demographic_data.hashCode ^
      cheif_complain.hashCode ^
      illness_hx.hashCode ^
      review_hx.hashCode ^
      meds_hx.hashCode ^
      pmh.hashCode ^
      psh.hashCode ^
      family_hx.hashCode ^
      physical_exam.hashCode ^
      vital_signs.hashCode ^
      followup_notes.hashCode ^
      ddx.hashCode ^
      management_plan.hashCode;
  }
}
