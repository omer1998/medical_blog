class CustomCaseModel {
  final String id;
  final String caseName;
  final String caseAuthorId;
  final String caseDetail;
  final List<String> tags;
  final bool structured;

  CustomCaseModel({required this.id, required this.caseName, required this.caseAuthorId, required this.caseDetail, required this.tags, required this.structured});

  copyWith({String? id, String? caseName, String? caseAuthorId, String? caseDetail, List<String>? tags, bool? structured}) {
    return CustomCaseModel(
      id: id ?? this.id,
      caseName: caseName ?? this.caseName,
      caseAuthorId: caseAuthorId ?? this.caseAuthorId,
      caseDetail: caseDetail ?? this.caseDetail,
      tags: tags ?? this.tags,
      structured: structured ?? this.structured,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "case_name": caseName,
      "case_author": caseAuthorId,
      "case_detail": caseDetail,
      "tags": tags,
      "structured": structured,
    };
  }
  factory CustomCaseModel.fromMap(Map<String, dynamic> map) {
    return CustomCaseModel(
      id: map["id"],
      caseName: map["case_name"],
      caseAuthorId: map["case_author"],
      caseDetail: map["case_detail"],
      tags: List<String>.from(map["tags"]),
      structured: map["structured"],
    );
  }
}