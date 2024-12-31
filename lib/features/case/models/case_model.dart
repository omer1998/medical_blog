import 'dart:convert';

import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // required: associates our `main.dart` with the code generated by Freezed
// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// // part 'models.freezed.dart';


// // final casee = Case(caseAuthorId: "dfjdifjd", caseName: "Case 1", demographicData: "Demographic Data", illnessHx: "Illness Hx", reviewHx: "Review Hx", medsHx: "Meds Hx", pmh: "PMH", psh: "PSH", familyHx: "Family Hx", physicalExam: "Physical Exam", vitalSigns: "Vital Signs", followUpNotes: "Follow Up Notes", ivx: "IVX", id: 'hfjhjsdhjhsjdh');

class MyCase {
  final String id;
  final String case_name;
  final String case_author;
  final String created_at;
  final bool structured;
  final String? case_detail;
  final String? name;
  final List<String>? tags;
  final CaseIvx? caseIvx;
  final CaseInfo? caseInfo;
  MyCase({
    required this.id,
    required this.case_name,
    required this.case_author,
    required this.created_at,
    required this.structured,
     this.case_detail,
    this.name,
    this.tags,
    this.caseIvx,
    this.caseInfo,
    // bool structed;
    // String case_detail;
  });
 


  MyCase copyWith({
    String? case_name,
    String? case_author,
    String? created_at,
    String? name,
    
    List<String>? tags,
    CaseIvx? caseIvx,
    CaseInfo? caseInfo,
    String? id,
    String? case_detail,
    bool? structured
  }) {
    return MyCase(
      structured: structured ?? this.structured,
      case_name: case_name ?? this.case_name,
      case_author: case_author ?? this.case_author,
      created_at: created_at ?? this.created_at,
      case_detail: case_detail ?? this.case_detail,
      name: name ?? this.name,
      tags: tags ?? this.tags,
      caseIvx: caseIvx ?? this.caseIvx,
      caseInfo: caseInfo ?? this.caseInfo,
      id: id ?? this.id
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'case_name': case_name,
      'case_author': case_author,
      'created_at': created_at,
      'tags': tags,
      'caseIvx': caseIvx?.toMap() ,
      'caseInfo': caseInfo?.toMap(),
      "id": id,
      "name": name,
      "case_detail": case_detail,
      "structured": structured
 
    };
  }

  factory MyCase.fromMap(Map<String, dynamic> map) {
    return MyCase(
      id: map["id"] as String,
      structured: map["structured"] as bool,
      case_name: map['case_name'] as String,
      case_author: map['case_author'] as String,
      created_at: map['created_at'] as String,
      case_detail: map['case_detail'] != null ? map['case_detail'] as String : null,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<dynamic>)) : null,
      name: map['profiles'] != null && map['profiles']["name"] != null ? map['profiles']["name"] as String : null,
      caseInfo: map['cases_infos'] != null ? CaseInfo.fromMap(map['cases_infos'][0]) : null,
      caseIvx: map['cases_invs'] != null ? CaseIvx.fromMap(map['cases_invs'][0]) : null
      );
  }

  factory MyCase.fromMapLocalDB(Map<String, dynamic> map) {
    return MyCase(
      structured: map["structured"] as bool,
      id: map["id"] as String,
      name: map["name"],
      case_name: map['case_name'] as String,
      case_author: map['case_author'] as String,
      created_at: map['created_at'] as String,
      case_detail: map['case_detail'] != null ? map['case_detail'] as String : null,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<dynamic>)) : null,
      caseInfo: map['caseInfo'] != null ? CaseInfo.fromMap((map['caseInfo'] as Map<dynamic, dynamic>).map((key, value) {
          return MapEntry(key.toString(), value);
        })) : null,
      caseIvx: map['caseIvx'] != null ? CaseIvx.fromMap((map['caseIvx'] as Map<dynamic, dynamic>).map((key, value) {
          return MapEntry(key.toString(), value);
        })) : null
      );
  }

  String toJson() => json.encode(toMap());

  factory MyCase.fromJson(String source) => MyCase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyCase(id: $id, case_name: $case_name, case_author: $case_author, created_at: $created_at, name: $name, tags: $tags, caseIvx: $caseIvx, caseInfo: $caseInfo)';
  }

  @override
  bool operator ==(covariant MyCase other) {
    if (identical(this, other)) return true;
  
    return 
      other.case_name == case_name &&
      other.case_author == case_author &&
      other.created_at == created_at &&
      other.name == name;

  }

  @override
  int get hashCode {
    return case_name.hashCode ^
      case_author.hashCode ^
      created_at.hashCode ^
      name.hashCode;
  }
  }


 class Case {
  final String id;
  final String caseName;
  final String caseAuthorId;
  final String demographicData;
  final String cheifComplain;
  final String illnessHx;
  final String reviewHx;
  final String medsHx;
  final String pmh;
  final String psh;
  final String familyHx;
  final String physicalExam;
  final String vitalSigns;
  final String followUpNotes;
  final String managementPlan;
  final String ddx;
  final String? ivx;
  final List<String>? tags;
  
  // final String authorName;
  Case({
    required this.tags,
    required this.id,
    required this.caseName,
    required this.caseAuthorId,
    required this.demographicData,
    required this.cheifComplain,
    required this.illnessHx,
    required this.reviewHx,
    required this.medsHx,
    required this.pmh,
    required this.psh,
    required this.familyHx,
    required this.physicalExam,
    required this.vitalSigns,
    required this.followUpNotes,
    required this.managementPlan,
    required this.ddx,
    this.ivx,
  });

  Case copyWith({
    String? id,
    String? caseName,
    String? caseAuthorId,
    String? demographicData,
    String? cheifComplain,
    String? illnessHx,
    String? reviewHx,
    String? medsHx,
    String? pmh,
    String? psh,
    String? familyHx,
    String? physicalExam,
    String? vitalSigns,
    String? followUpNotes,
    String? managementPlan,
    String? ddx,
    String? ivx,
    List<String>? tags
  }) {
    return Case(
      tags: tags ?? this.tags,
      id: id ?? this.id,
      caseName: caseName ?? this.caseName,
      caseAuthorId: caseAuthorId ?? this.caseAuthorId,
      demographicData: demographicData ?? this.demographicData,
      cheifComplain: cheifComplain ?? this.cheifComplain,
      illnessHx: illnessHx ?? this.illnessHx,
      reviewHx: reviewHx ?? this.reviewHx,
      medsHx: medsHx ?? this.medsHx,
      pmh: pmh ?? this.pmh,
      psh: psh ?? this.psh,
      familyHx: familyHx ?? this.familyHx,
      physicalExam: physicalExam ?? this.physicalExam,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      managementPlan: managementPlan ?? this.managementPlan,
      ddx: ddx ?? this.ddx,
      ivx: ivx ?? this.ivx,
    );
  }

  // Map<String, dynamic> 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'case_name': caseName,
      'case_author': caseAuthorId,
      'demographic_data': demographicData,
      'cheif_complain': cheifComplain,
      'illness_hx': illnessHx,
      'review_hx': reviewHx,
      'meds_hx': medsHx,
      'pmh': pmh,
      'psh': psh,
      'family_hx': familyHx,
      'physical_exam': physicalExam,
      'vital_signs': vitalSigns,
      'followUp_notes': followUpNotes,
      'management_plan': managementPlan,
      'ddx': ddx,
      'ivx': ivx,
      'tags': tags
    };
  }

  factory Case.fromMap(Map<String, dynamic> map) {
    return Case(
      id: map['id'] as String,
      caseName: map['caseName'] as String,
      caseAuthorId: map['caseAuthorId'] as String,
      demographicData: map['demographicData'] as String,
      cheifComplain: map['cheifComplain'] as String,
      illnessHx: map['illnessHx'] as String,
      reviewHx: map['reviewHx'] as String,
      medsHx: map['medsHx'] as String,
      pmh: map['pmh'] as String,
      psh: map['psh'] as String,
      familyHx: map['familyHx'] as String,
      physicalExam: map['physicalExam'] as String,
      vitalSigns: map['vitalSigns'] as String,
      followUpNotes: map['followUpNotes'] as String,
      managementPlan: map['managementPlan'] as String,
      ddx: map['ddx'] as String,
      ivx: map['ivx'] != null ? map['ivx'] as String : null,
      tags: map['tags'] != null ? List<String>.from((map['tags'] as List<dynamic>)) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Case.fromJson(String source) => Case.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Case(id: $id, caseName: $caseName, caseAuthorId: $caseAuthorId, demographicData: $demographicData, cheifComplain: $cheifComplain, illnessHx: $illnessHx, reviewHx: $reviewHx, medsHx: $medsHx, pmh: $pmh, psh: $psh, familyHx: $familyHx, physicalExam: $physicalExam, vitalSigns: $vitalSigns, followUpNotes: $followUpNotes, managementPlan: $managementPlan, ddx: $ddx, ivx: $ivx)';
  }

  @override
  bool operator ==(covariant Case other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.caseName == caseName &&
      other.caseAuthorId == caseAuthorId &&
      other.demographicData == demographicData &&
      other.cheifComplain == cheifComplain &&
      other.illnessHx == illnessHx &&
      other.reviewHx == reviewHx &&
      other.medsHx == medsHx &&
      other.pmh == pmh &&
      other.psh == psh &&
      other.familyHx == familyHx &&
      other.physicalExam == physicalExam &&
      other.vitalSigns == vitalSigns &&
      other.followUpNotes == followUpNotes &&
      other.managementPlan == managementPlan &&
      other.ddx == ddx &&
      other.ivx == ivx;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      caseName.hashCode ^
      caseAuthorId.hashCode ^
      demographicData.hashCode ^
      cheifComplain.hashCode ^
      illnessHx.hashCode ^
      reviewHx.hashCode ^
      medsHx.hashCode ^
      pmh.hashCode ^
      psh.hashCode ^
      familyHx.hashCode ^
      physicalExam.hashCode ^
      vitalSigns.hashCode ^
      followUpNotes.hashCode ^
      managementPlan.hashCode ^
      ddx.hashCode ^
      ivx.hashCode;
  }
}
