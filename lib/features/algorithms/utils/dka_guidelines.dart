import 'package:medical_blog_app/features/algorithms/models/dka_reading.dart';

class DKAGuidelines {
  static List<String> evaluateReading(DKAReading currentReading, DKAReading? previousReading) {
    final List<String> warnings = [];
    final List<String> recommendations = [];

    // Potassium and Insulin Guidelines
    if (currentReading.potassiumLevel < 3.5) {
      warnings.add('⚠️ WARNING: Potassium level below 3.5 mEq/L - DO NOT administer insulin until corrected');
      recommendations.add('🔸 Correct potassium levels before initiating insulin therapy');
    }

    // Glucose Rate of Change Warning
    if (previousReading != null) {
      final glucoseChange = previousReading.glucoseLevel - currentReading.glucoseLevel;
      if (glucoseChange >= 100) {
        warnings.add('⚠️ WARNING: Blood glucose decreasing too rapidly (≥100 mg/dL per hour)');
        recommendations.add('🔸 Consider reducing insulin dose');
      }
    }

    // Fluid Type Recommendations
    if (currentReading.glucoseLevel > 200 && currentReading.fluidType != 'Normal Saline') {
      recommendations.add('🔸 Consider using Normal Saline while glucose > 200 mg/dL');
    } else if (currentReading.glucoseLevel <= 200 && currentReading.fluidType != '0.45% Normal Saline + 5% Dextrose') {
      recommendations.add('🔸 Consider switching to 0.45% Normal Saline + 5% Dextrose (glucose ≤ 200 mg/dL)');
    }

    // Fluid Rate Recommendations based on Hydration Status
    _addFluidRecommendations(currentReading, recommendations);

    // Potassium Replacement Guidelines
    _addPotassiumRecommendations(currentReading, recommendations, warnings);

    // Hydration Status Assessment
    _addHydrationAssessment(currentReading, recommendations);

    return [...warnings, ...recommendations];
  }

  static void _addFluidRecommendations(DKAReading reading, List<String> recommendations) {
    if (reading.hydrationStatus == HydrationStatus.severe) {
      recommendations.add('🔸 Give 1L fluid bolus and reassess hydration status in 1 hour');
    } else if (reading.hydrationStatus == HydrationStatus.moderate) {
      recommendations.add('🔸 Consider fluid rate 250-500 mL/hr until glucose reaches 200 mg/dL');
    } else if (reading.glucoseLevel <= 200) {
      recommendations.add('🔸 Maintain fluid rate at 150-250 mL/hr');
    }
  }

  static void _addPotassiumRecommendations(
    DKAReading reading,
    List<String> recommendations,
    List<String> warnings,
  ) {
    if (reading.urineOutput < 50) {
      warnings.add('⚠️ WARNING: Inadequate urine output for potassium replacement');
      return;
    }

    if (reading.potassiumLevel < 3.3) {
      recommendations.add('🔸 Add 20-40 mEq KCl per liter of IV fluids');
    } else if (reading.potassiumLevel >= 3.3 && reading.potassiumLevel < 5.3) {
      recommendations.add('🔸 Add 20-30 mEq KCl per liter of IV fluids');
    } else if (reading.potassiumLevel >= 5.3) {
      recommendations.add('🔸 Hold potassium replacement');
    }
  }

  static void _addHydrationAssessment(DKAReading reading, List<String> recommendations) {
    final List<String> improvements = [];
    final List<String> concerns = [];

    if (reading.capillaryRefillTime > 2) {
      concerns.add('prolonged capillary refill');
    }
    if (reading.pulseRate > 100) {
      concerns.add('tachycardia');
    }
    if (reading.shockIndex > 0.7) {
      concerns.add('elevated shock index');
    }
    if (reading.urineOutput < 0.5) {
      concerns.add('low urine output');
    }

    if (concerns.isNotEmpty) {
      recommendations.add('🔸 Hydration concerns: ${concerns.join(", ")}');
    } else {
      recommendations.add('✅ Hydration status improving');
    }
  }
}
