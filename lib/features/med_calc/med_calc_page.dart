import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/algorithms/pages/omi_algorithm_page.dart';
import 'package:medical_blog_app/features/med_calc/med_calc_view_page.dart';

class MedCalcPage extends ConsumerStatefulWidget {
  const MedCalcPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MedCalcPageState();
}

class _MedCalcPageState extends ConsumerState<MedCalcPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text(
          'Medical Tools',
          style: TextStyle(color: AppPallete.whiteColor),
        ),
        iconTheme: IconThemeData(color: AppPallete.whiteColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            _buildSectionTitle('Medical Calculators'),
            const SizedBox(height: 16),
            _buildCalculatorCard(
              title: 'Creatinine Clearance',
              subtitle: 'Cockcroft-Gault Equation',
              url:
                  'https://www.mdcalc.com/calc/43/creatinine-clearance-cockcroft-gault-equation',
              icon: Icons.science_outlined,
            ),
            
            const SizedBox(height: 12),
            _buildCalculatorCard(
              title: 'OMI GUIDE',
              subtitle:
                  'Learn to identify occlusion myocardial infarctions (OMIs)',
              url: 'https://omiguide.org/',
              icon: Icons.monitor_heart_outlined,
            ),
            const SizedBox(
              height: 12,
            ),
            _buildCalculatorCard(
              title: "Upper GIT bleeding risk",
              subtitle: "Glasgow-Blatchford Bleeding Score Stratifies upper GI bleeding patients who are \"low-risk\" and candidates for outpatient management.",
              url:
                  "https://www.mdcalc.com/calc/518/glasgow-blatchford-bleeding-score-gbs",
              icon: Icons.bloodtype,
            ),
            const SizedBox(
              height: 12,
            ),
            _buildCalculatorCard(
              title: "Wells' Criteria for Pulmonary Embolism"
,
              subtitle: "Objectifies risk of pulmonary embolism",
              url:
                  "https://www.mdcalc.com/calc/115/wells-criteria-pulmonary-embolism",
              icon: Icons.monitor_sharp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppPallete.whiteColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAlgorithmCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      color: AppPallete.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppPallete.gradient1.withOpacity(0.2)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppPallete.gradient1.withOpacity(0.1),
                AppPallete.backgroundColor,
              ],
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: AppPallete.gradient1,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppPallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppPallete.whiteColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppPallete.gradient1,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard({
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      color: AppPallete.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedCalcViewPage(
              title: title,
              url: url,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppPallete.gradient2.withOpacity(0.2)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppPallete.gradient2.withOpacity(0.1),
                AppPallete.backgroundColor,
              ],
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: AppPallete.gradient2,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppPallete.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppPallete.whiteColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppPallete.gradient2,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
