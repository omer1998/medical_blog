class DKAReading {
  final DateTime timestamp;
  final double glucoseLevel; // mg/dL
  final double fluidGiven; // mL
  final String fluidType; // NS or 0.45% NS
  final double insulinDose; // units
  final double urineOutput; // mL/kg/hr
  final String consciousnessLevel;
  final double potassiumLevel; // mEq/L
  final double bicarbonateLevel; // mEq/L
  final double pH;
  final int pulseRate;
  final double systolicBP;
  final double diastolicBP;
  final int capillaryRefillTime; // seconds
  final double shockIndex; // HR/SBP
  final HydrationStatus hydrationStatus;
  final double potassiumInFluids; // mEq/L added to fluids

  DKAReading({
    required this.timestamp,
    required this.glucoseLevel,
    required this.fluidGiven,
    required this.fluidType,
    required this.insulinDose,
    required this.urineOutput,
    required this.consciousnessLevel,
    required this.potassiumLevel,
    required this.bicarbonateLevel,
    required this.pH,
    required this.pulseRate,
    required this.systolicBP,
    required this.diastolicBP,
    required this.capillaryRefillTime,
    required this.hydrationStatus,
    required this.potassiumInFluids,
  }) : shockIndex = pulseRate / systolicBP;

  static List<String> consciousnessLevels = [
    'Conscious',
    'Drowsy',
    'Confused',
    'Stupor',
    'Obtunded',
    'Comatose',
  ];

  static List<String> fluidTypes = [
    'Normal Saline',
    '0.45% Normal Saline + 5% Dextrose',
  ];

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'glucoseLevel': glucoseLevel,
      'fluidGiven': fluidGiven,
      'fluidType': fluidType,
      'insulinDose': insulinDose,
      'urineOutput': urineOutput,
      'consciousnessLevel': consciousnessLevel,
      'potassiumLevel': potassiumLevel,
      'bicarbonateLevel': bicarbonateLevel,
      'pH': pH,
      'pulseRate': pulseRate,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'capillaryRefillTime': capillaryRefillTime,
      'hydrationStatus': hydrationStatus.toString(),
      'potassiumInFluids': potassiumInFluids,
    };
  }

  factory DKAReading.fromJson(Map<String, dynamic> json) {
    return DKAReading(
      timestamp: DateTime.parse(json['timestamp']),
      glucoseLevel: json['glucoseLevel'],
      fluidGiven: json['fluidGiven'],
      fluidType: json['fluidType'],
      insulinDose: json['insulinDose'],
      urineOutput: json['urineOutput'],
      consciousnessLevel: json['consciousnessLevel'],
      potassiumLevel: json['potassiumLevel'],
      bicarbonateLevel: json['bicarbonateLevel'],
      pH: json['pH'],
      pulseRate: json['pulseRate'],
      systolicBP: json['systolicBP'],
      diastolicBP: json['diastolicBP'],
      capillaryRefillTime: json['capillaryRefillTime'],
      hydrationStatus: HydrationStatus.values.firstWhere(
        (e) => e.toString() == json['hydrationStatus'],
      ),
      potassiumInFluids: json['potassiumInFluids'],
    );
  }
}

enum HydrationStatus {
  severe,
  moderate,
  mild,
  normal
}
