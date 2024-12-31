class OMIAlgorithm {
  static const List<Map<String, dynamic>> steps = [
    {
      'title': 'Initial Assessment',
      'question': 'Does the patient have symptoms concerning for ACS?',
      'explanation': '''
• Chest pain/pressure/tightness
• Dyspnea
• Diaphoresis
• Nausea/vomiting
• Syncope/near-syncope
• Unexplained weakness
• Upper extremity pain
• Jaw/neck/throat pain
• Epigastric pain''',
      'options': ['Yes', 'No'],
      'recommendations': {
        'Yes': 'Proceed with ECG evaluation',
        'No': 'Consider other diagnoses'
      },
    },
    {
      'title': 'ECG Evaluation',
      'question': 'Are any of these OMI patterns present on ECG?',
      'explanation': '''
1. ST Elevation meeting STEMI criteria:
   • V2-V3: ≥2mm in men, ≥1.5mm in women
   • All other leads: ≥1mm
   
2. Hyperacute T-waves:
   • Tall, broad-based, symmetrical
   • Usually in contiguous leads
   
3. De Winter pattern:
   • Upsloping ST depression
   • Tall, symmetric T waves in precordial leads
   
4. Wellens syndrome:
   • Biphasic or deeply inverted T waves in V2-V3
   
5. Posterior OMI:
   • ST depression in V1-V4
   • Tall R waves in V1-V2
   • Upright T waves in V1
   
6. ST depression with straight ST segments''',
      'options': ['Yes - Classic STEMI', 'Yes - Other OMI pattern', 'No'],
      'recommendations': {
        'Yes - Classic STEMI': 'Immediate cath lab activation',
        'Yes - Other OMI pattern': 'Consider immediate cath lab activation',
        'No': 'Proceed with further evaluation'
      },
    },
    {
      'title': 'Additional Risk Assessment',
      'question': 'Are high-risk features present?',
      'explanation': '''
High-risk features include:

1. Hemodynamic:
   • Hypotension
   • Pulmonary edema
   
2. Electrical:
   • VT/VF
   • New heart block
   
3. Clinical:
   • Ongoing chest pain
   • Heart failure
   • Cardiogenic shock
   
4. Biomarkers:
   • Rising troponin
   • Significantly elevated troponin''',
      'options': ['Yes', 'No'],
      'recommendations': {
        'Yes': 'Consider urgent cardiac catheterization',
        'No': 'Serial ECGs and troponin monitoring'
      },
    },
    {
      'title': 'Serial Evaluation',
      'question': 'Are there dynamic ECG changes or rising troponin?',
      'explanation': '''
Monitor for:

1. ECG Changes:
   • New ST deviation
   • T wave changes
   • Development of Q waves
   
2. Troponin:
   • Rising values
   • Significant delta change
   
3. Symptoms:
   • Recurrent chest pain
   • Worsening symptoms''',
      'options': ['Yes', 'No'],
      'recommendations': {
        'Yes': 'Consider urgent cardiac catheterization',
        'No': 'Continue risk stratification and medical management'
      },
    }
  ];

  static Map<String, String> getRecommendation(int step, String choice) {
    final recommendations = {
      'Immediate cath lab activation': '''
• Activate cardiac catheterization laboratory
• Start dual antiplatelet therapy
• Consider anticoagulation
• Manage pain and anxiety''',
      
      'Consider immediate cath lab activation': '''
• Strong consideration for immediate cardiac catheterization
• Start dual antiplatelet therapy
• Consider anticoagulation
• Serial ECGs if any delay''',
      
      'Consider urgent cardiac catheterization': '''
• Urgent cardiac catheterization within 24 hours
• Optimal medical therapy
• Monitor for decompensation
• Serial ECGs and troponins''',
      
      'Serial ECGs and troponin monitoring': '''
• Repeat ECG every 15-30 minutes if concerned
• Serial troponin measurements
• Consider non-invasive testing
• Optimize medical therapy''',
      
      'Continue risk stratification and medical management': '''
• Complete risk stratification
• Consider non-invasive testing
• Optimize medical therapy
• Arrange follow-up care''',
      
      'Consider other diagnoses': '''
• Evaluate for other causes
• Risk stratify based on presentation
• Consider non-cardiac chest pain
• Arrange appropriate follow-up'''
    };
    
    final stepData = steps[step];
    final recommendation = stepData['recommendations'][choice];
    return {
      'short': recommendation,
      'detailed': recommendations[recommendation] ?? '',
    };
  }
}