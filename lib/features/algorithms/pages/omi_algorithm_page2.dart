import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/algorithms/models/omi_algorithm_2.dart';

class OMIAlgorithmPage2 extends StatefulWidget {
  const OMIAlgorithmPage2({super.key});

  @override
  State<OMIAlgorithmPage2> createState() => _OMIAlgorithmPage2State();
}

class _OMIAlgorithmPage2State extends State<OMIAlgorithmPage2> {
  int currentStep = 0;
  List<String> choices = [];
  bool showRecommendation = false;

  void _makeChoice(String choice) {
    setState(() {
      choices.add(choice);
      showRecommendation = true;
    });
  }

  void _nextStep() {
    if (currentStep < OMIAlgorithm.steps.length - 1) {
      setState(() {
        currentStep++;
        showRecommendation = false;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        choices.removeLast();
        showRecommendation = choices.length > currentStep;
      });
    }
  }

  void _restart() {
    setState(() {
      currentStep = 0;
      choices.clear();
      showRecommendation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = OMIAlgorithm.steps[currentStep];
    final hasChoice = choices.length > currentStep;
    final recommendation = hasChoice
        ? OMIAlgorithm.getRecommendation(currentStep, choices[currentStep])
        : null;

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: const Text('OMI Algorithm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _restart,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (currentStep + 1) / OMIAlgorithm.steps.length,
                backgroundColor: AppPallete.backgroundColor,
                color: AppPallete.gradient1,
              ),
              const SizedBox(height: 24),

              // Step title
              Text(
                step['title'],
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Question
              Text(
                step['question'],
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),

              // Explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPallete.backgroundColor,
                  border: Border.all(color: AppPallete.gradient2.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Points:',
                      style: TextStyle(
                        color: AppPallete.gradient2,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['explanation'],
                      style: TextStyle(
                        color: AppPallete.whiteColor.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Options
              if (!hasChoice) ...[
                for (final option in step['options'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _makeChoice(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.gradient1.withOpacity(0.1),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: AppPallete.gradient1.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],

              // Recommendation
              if (showRecommendation && recommendation != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPallete.gradient1.withOpacity(0.1),
                    border: Border.all(color: AppPallete.gradient1.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendation:',
                        style: TextStyle(
                          color: AppPallete.gradient1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recommendation['short']!,
                        style: TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        recommendation['detailed']!,
                        style: TextStyle(
                          color: AppPallete.whiteColor.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (currentStep < OMIAlgorithm.steps.length - 1)
                        ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.gradient1,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Next Step'),
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    TextButton.icon(
                      onPressed: _previousStep,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppPallete.whiteColor,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  TextButton.icon(
                    onPressed: _restart,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Restart'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppPallete.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}