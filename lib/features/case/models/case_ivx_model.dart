// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CaseIvx {
  final String id;
  final String inv_data;
  final List<String> inv_imgs;
  CaseIvx({
    required this.id,
    required this.inv_data,
    required this.inv_imgs,
  });

  CaseIvx copyWith({
    String? id,
    String? inv_data,
    List<String>? inv_imgs,
  }) {
    return CaseIvx(
      id: id ?? this.id,
      inv_data: inv_data ?? this.inv_data,
      inv_imgs: inv_imgs ?? this.inv_imgs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'inv_data': inv_data,
      'inv_imgs': inv_imgs,
    };
  }

  factory CaseIvx.fromMap(Map<String, dynamic> map) {
    return CaseIvx(
      id: map['id'] as String,
      inv_data: map['inv_data'] as String,
      inv_imgs: map["inv_imgs"] != null && map['inv_imgs'].isNotEmpty ? List<String>.from((map['inv_imgs'] as List<dynamic>)) : <String>[]
    );
  }

  String toJson() => json.encode(toMap());

  factory CaseIvx.fromJson(String source) => CaseIvx.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CaseIvx(id: $id, inv_data: $inv_data, inv_imgs: $inv_imgs)';

  @override
  bool operator ==(covariant CaseIvx other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.inv_data == inv_data &&
      listEquals(other.inv_imgs, inv_imgs);
  }

  @override
  int get hashCode => id.hashCode ^ inv_data.hashCode ^ inv_imgs.hashCode;
}
