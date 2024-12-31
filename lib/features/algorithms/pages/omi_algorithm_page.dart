import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/algorithms/models/omi_algorithm.dart';

class OMIAlgorithmPage extends StatefulWidget {
  const OMIAlgorithmPage({super.key});

  @override
  State<OMIAlgorithmPage> createState() => _OMIAlgorithmPageState();
}

class _OMIAlgorithmPageState extends State<OMIAlgorithmPage> {
  int currentStep = 0;
  List<int> history = [0];

  void _handleOptionSelected(int optionIndex) {
    final nextStep = OMIAlgorithm.steps[currentStep].nextSteps[optionIndex];
    if (nextStep >= 0) {
      setState(() {
        currentStep = nextStep;
        history.add(nextStep);
      });
    }
  }

  void _goBack() {
    if (history.length > 1) {
      setState(() {
        history.removeLast();
        currentStep = history.last;
      });
    }
  }

  void _restart() {
    setState(() {
      currentStep = 0;
      history = [0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = OMIAlgorithm.steps[currentStep];

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text(
          'OMI Algorithm',
          style: TextStyle(color: AppPallete.whiteColor),
        ),
        iconTheme: IconThemeData(color: AppPallete.whiteColor),
        actions: [
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: _restart,
            tooltip: 'Restart Algorithm',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              _buildQuestionCard(step),
              if (step.explanation != null) ...[
                const SizedBox(height: 16),
                _buildExplanationCard(step.explanation!),
              ],
              if (step.recommendation != null) ...[
                const SizedBox(height: 16),
                _buildRecommendationCard(step),
              ],
              const SizedBox(height: 24),
              _buildOptionsGrid(step),
              if (history.length > 1) ...[
                const SizedBox(height: 16),
                _buildBackButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (currentStep + 1) / OMIAlgorithm.steps.length,
      backgroundColor: AppPallete.gradient2.withOpacity(0.2),
      valueColor: AlwaysStoppedAnimation<Color>(AppPallete.gradient1),
    );
  }

  Widget _buildQuestionCard(OMIStep step) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppPallete.backgroundColor,
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
        child: Text(
          step.question,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppPallete.whiteColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildExplanationCard(String explanation) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppPallete.backgroundColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPallete.gradient2.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppPallete.gradient2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              explanation,
              style: TextStyle(
                fontSize: 14,
                color: AppPallete.whiteColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(OMIStep step) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppPallete.backgroundColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (step.recommendationColor ?? AppPallete.gradient1).withOpacity(0.4),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (step.recommendationColor ?? AppPallete.gradient1).withOpacity(0.2),
              AppPallete.backgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.medical_services_outlined,
              color: step.recommendationColor ?? AppPallete.gradient1,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Recommendation:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: step.recommendationColor ?? AppPallete.gradient1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              step.recommendation!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppPallete.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(OMIStep step) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: step.options.length > 2 ? 2 : step.options.length,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: step.options.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () => _handleOptionSelected(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.gradient1.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: AppPallete.gradient1.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
          child: Text(
            step.options[index],
            style: TextStyle(
              color: AppPallete.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      onPressed: _goBack,
      icon: Icon(Icons.arrow_back, color: AppPallete.gradient2),
      label: Text(
        'Go Back',
        style: TextStyle(color: AppPallete.gradient2),
      ),
      style: TextButton.styleFrom(
        backgroundColor: AppPallete.gradient2.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppPallete.gradient2.withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
