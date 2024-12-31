class OMIGuide {
  static const List<Map<String, dynamic>> sections = [
    {
      'title': 'Classic STEMI Patterns',
      'description': 'Traditional ST-elevation criteria that indicate acute coronary occlusion',
      'content': '''
• V2-V3: ≥2mm (men) or ≥1.5mm (women)
• Other leads: ≥1mm in 2 contiguous leads
• True posterior MI: ST depression V1-V3 with tall R waves''',
      'imageUrl': 'assets/images/omi/stemi.png',
      'considerations': '''
- Remember these are only traditional criteria
- Many OMIs do not meet these criteria
- Some non-OMIs may meet these criteria
- Clinical context is crucial'''
    },
    {
      'title': 'Hyperacute T-waves',
      'description': 'Early sign of coronary occlusion, often preceding ST elevation',
      'content': '''
• Tall, broad-based T waves
• Usually symmetric
• Often larger than QRS complex
• Most common in LAD occlusion''',
      'imageUrl': 'assets/images/omi/hyperacute_t.png',
      'considerations': '''
- May be the earliest sign of occlusion
- Can be subtle and easily missed
- Compare with prior ECGs if available
- Often dynamic and evolving'''
    },
    {
      'title': 'De Winter Pattern',
      'description': 'Specific pattern indicating proximal LAD occlusion',
      'content': '''
• Upsloping ST depression V1-V6
• Tall, symmetric T waves
• Often with minimal ST elevation in aVR
• Usually indicates proximal LAD occlusion''',
      'imageUrl': 'assets/images/omi/dewinter.png',
      'considerations': '''
- STEMI equivalent pattern
- Requires immediate cath lab activation
- Highly specific for LAD occlusion
- May be static (not evolving)'''
    },
    {
      'title': 'Wellens Syndrome',
      'description': 'Pattern indicating critical LAD stenosis or recent reperfusion',
      'content': '''
Type A (25%):
• Biphasic T waves in V2-V3

Type B (75%):
• Deep, symmetric T wave inversions V2-V3
• May extend to V1-V6''',
      'imageUrl': 'assets/images/omi/wellens.png',
      'considerations': '''
- High risk for anterior wall MI
- May occur after reperfusion
- Pain-free when ECG recorded
- Don't stress test these patients'''
    },
    {
      'title': 'Posterior OMI',
      'description': 'Often missed pattern of posterior wall infarction',
      'content': '''
• ST depression V1-V4
• Tall R waves V1-V2 (>30ms wide)
• Upright T waves V1-V2
• Often with inferior or lateral changes''',
      'imageUrl': 'assets/images/omi/post_omi.png',
      'considerations': '''
- Look for mirror image in V7-V9
- Often associated with RCA/Cx occlusion
- Commonly missed STEMI equivalent
- Consider posterior leads'''
    },
    {
      'title': 'Subtle Anterior OMI',
      'description': 'Subtle signs of anterior wall occlusion',
      'content': '''
• Minimal ST elevation
• Terminal QRS distortion
• Loss of S waves V2-V3
• Convex ST segments''',
      'imageUrl': 'assets/images/omi/subtle_anterior.png',
      'considerations': '''
- Don't rely solely on millimeter criteria
- Compare with prior ECGs
- Look for reciprocal changes
- Consider serial ECGs'''
    }
  ];

  static const List<Map<String, dynamic>> keyPrinciples = [
    {
      'title': 'General Principles',
      'points': [
        'OMI is more accurate than STEMI criteria',
        'Many OMIs do not meet STEMI criteria',
        'Some STEMIs are not occlusions',
        'Clinical context is crucial',
        'Serial ECGs are valuable'
      ]
    },
    {
      'title': 'High-Risk Features',
      'points': [
        'Ongoing chest pain',
        'Hemodynamic instability',
        'Heart failure signs',
        'Dynamic ECG changes',
        'Rising troponin'
      ]
    },
    {
      'title': 'Common Pitfalls',
      'points': [
        'Over-reliance on millimeter criteria',
        'Missing subtle patterns',
        'Ignoring clinical context',
        'Not getting serial ECGs',
        'Delayed recognition of equivalents'
      ]
    }
  ];
}