import 'package:medical_blog_app/features/algorithms/models/dka_reading.dart';

class DKAPatient {
  final String id;
  final String name;
  final int age;
  final double weight;
  final String briefHistory;
  final DateTime admissionTime;
  final List<DKAReading> readings;

  DKAPatient({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.briefHistory,
    required this.admissionTime,
    this.readings = const [],
  });

  DKAPatient copyWith({
    String? id,
    String? name,
    int? age,
    double? weight,
    String? briefHistory,
    DateTime? admissionTime,
    List<DKAReading>? readings,
  }) {
    return DKAPatient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      briefHistory: briefHistory ?? this.briefHistory,
      admissionTime: admissionTime ?? this.admissionTime,
      readings: readings ?? this.readings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'briefHistory': briefHistory,
      'admissionTime': admissionTime.toIso8601String(),
      'readings': readings.map((r) => r.toJson()).toList(),
    };
  }

  factory DKAPatient.fromJson(Map<String, dynamic> json) {
    return DKAPatient(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      weight: json['weight'],
      briefHistory: json['briefHistory'],
      admissionTime: DateTime.parse(json['admissionTime']),
      readings: (json['readings'] as List)
          .map((r) => DKAReading.fromJson(r))
          .toList(),
    );
  }
}
