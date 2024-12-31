import 'package:flutter/material.dart';

class OMIStep {
  final String question;
  final List<String> options;
  final List<int> nextSteps;
  final String? recommendation;
  final String? explanation;
  final Color? recommendationColor;

  OMIStep({
    required this.question,
    required this.options,
    required this.nextSteps,
    this.recommendation,
    this.explanation,
    this.recommendationColor,
  });
}

class OMIAlgorithm {
  static List<OMIStep> steps = [
    OMIStep(
      question: "Does the patient have concerning symptoms for ACS?",
      options: ["Yes", "No"],
      nextSteps: [1, -1],
      explanation: "Consider: Chest pain, shortness of breath, diaphoresis, nausea, etc.",
    ),
    OMIStep(
      question: "Is there ST elevation meeting STEMI criteria?",
      options: ["Yes", "No"],
      nextSteps: [2, 3],
      explanation: "Classic STEMI criteria: ST elevation ≥1mm in 2 contiguous leads",
    ),
    OMIStep(
      question: "Are there any contraindications to PCI?",
      options: ["No contraindications", "Has contraindications"],
      nextSteps: [-1, -1],
      recommendation: "Activate Cath Lab for immediate PCI",
      recommendationColor: Colors.red,
      explanation: "Time is muscle - aim for door-to-balloon time <90 minutes",
    ),
    OMIStep(
      question: "Are there OMI patterns without classic STE?",
      options: ["Yes", "No"],
      nextSteps: [4, 5],
      explanation: "Look for: Hyperacute T-waves, De Winter pattern, Wellens syndrome, etc.",
    ),
    OMIStep(
      question: "Is the patient hemodynamically stable?",
      options: ["Yes", "No"],
      nextSteps: [-1, -1],
      recommendation: "Consider immediate PCI - Consult cardiology",
      recommendationColor: Colors.orange,
      explanation: "High-risk features warrant early invasive strategy",
    ),
    OMIStep(
      question: "Are there high-risk features?",
      options: ["Yes", "No"],
      nextSteps: [6, -1],
      explanation: "Consider: Ongoing pain, dynamic ECG changes, elevated troponin, etc.",
    ),
    OMIStep(
      question: "Is early invasive strategy indicated?",
      options: ["Yes", "No"],
      nextSteps: [-1, -1],
      recommendation: "Medical management and risk stratification",
      recommendationColor: Colors.blue,
      explanation: "Consider GRACE score for risk stratification",
    ),
  ];
}
