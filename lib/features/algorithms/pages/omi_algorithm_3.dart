import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/algorithms/models/omi_algorithm_2.dart';
import 'package:medical_blog_app/features/algorithms/models/omi_model3.dart';

class OMIAlgorithmPage3 extends StatefulWidget {
  const OMIAlgorithmPage3({super.key});

  @override
  State<OMIAlgorithmPage3> createState() => _OMIAlgorithmPage3State();
}

class _OMIAlgorithmPage3State extends State<OMIAlgorithmPage3> {
  final _scrollController = ScrollController();
  int _selectedSection = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: const Text('OMI Guide'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (var i = 0; i < OMIGuide.sections.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        OMIGuide.sections[i]['title'],
                        style: TextStyle(
                          color: _selectedSection == i
                              ? AppPallete.backgroundColor
                              : AppPallete.whiteColor,
                        ),
                      ),
                      selected: _selectedSection == i,
                      selectedColor: AppPallete.gradient1,
                      backgroundColor: AppPallete.backgroundColor,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedSection = i);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selected section content
            _buildSection(OMIGuide.sections[_selectedSection]),

            const Divider(height: 32),

            // Key principles
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final principle in OMIGuide.keyPrinciples)
                    _buildPrincipleCard(principle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title and description
          Text(
            section['title'],
            style: TextStyle(
              color: AppPallete.whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section['description'],
            style: TextStyle(
              color: AppPallete.whiteColor.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPallete.gradient1.withOpacity(0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: 
              Image.asset(
                section['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.gradient1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPallete.gradient1.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Features:',
                  style: TextStyle(
                    color: AppPallete.gradient1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section['content'],
                  style: TextStyle(
                    color: AppPallete.whiteColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Considerations
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.gradient2.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPallete.gradient2.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinical Considerations:',
                  style: TextStyle(
                    color: AppPallete.gradient2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section['considerations'],
                  style: TextStyle(
                    color: AppPallete.whiteColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrincipleCard(Map<String, dynamic> principle) {
    return Card(
      color: AppPallete.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppPallete.gradient1.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              principle['title'],
              style: TextStyle(
                color: AppPallete.gradient1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...principle['points'].map<Widget>((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_right,
                        color: AppPallete.gradient2,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            color: AppPallete.whiteColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}