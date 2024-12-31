import 'package:flutter/material.dart';
import 'package:medical_blog_app/features/algorithms/pages/blood_gas_interpreter_page.dart';
import 'package:medical_blog_app/features/algorithms/pages/dka_monitoring_page.dart';
import 'package:medical_blog_app/features/algorithms/pages/omi_algorithm_3.dart';
import 'package:medical_blog_app/features/algorithms/pages/omi_algorithm_page.dart';
import 'package:medical_blog_app/features/algorithms/pages/omi_algorithm_page2.dart';

class AlgorithmPage extends StatelessWidget {
  const AlgorithmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Algorithms'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _WelcomeHeader(),
              const SizedBox(height: 24),
              _buildAlgorithmSection(context, 'Critical Care'),
              const SizedBox(height: 24),
              _buildAlgorithmSection(context, 'Emergency Medicine'),
              const SizedBox(height: 24),
              _buildAlgorithmSection(context, 'Internal Medicine'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlgorithmSection(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        const SizedBox(height: 16),
        if (title == 'Critical Care') _buildCriticalCareAlgorithms(context),
        if (title == 'Emergency Medicine') _buildEmergencyAlgorithms(context),
        if (title == 'Internal Medicine') _buildInternalMedicineAlgorithms(context),
      ],
    );
  }

  Widget _buildCriticalCareAlgorithms(BuildContext context) {
    return Column(
      children: [
        _AlgorithmCard(
          title: 'DKA Monitoring',
          description: 'Real-time DKA patient monitoring with clinical insights and trend analysis',
          icon: Icons.monitor_heart,
          color: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DKAMonitoringPage()),
          ),
        ),
        const SizedBox(height: 12),
        _AlgorithmCard(
          title: 'Sepsis Management',
          description: 'Step-by-step sepsis bundle implementation and monitoring',
          icon: Icons.medical_services,
          color: Colors.red,
          comingSoon: true,
        ),
        const SizedBox(height: 12),
        _AlgorithmCard(title: "Blood gas analysis", description: "Real-time blood gas analysis and monitoring", icon: Icons.bloodtype, color: Colors.purple, onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BloodGasInterpreterPage()),
          ),),
      ],
    );
  }

  Widget _buildEmergencyAlgorithms(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        _AlgorithmCard(
              title: 'O MI God a.k.a guide',
              description: 'Occlusive Myocardial Infarction diagnosis and PCI decision support',
              icon: Icons.favorite_border,
              color: const Color.fromARGB(255, 229, 57, 53),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OMIAlgorithmPage3()),
              ),
            ),
        _AlgorithmCard(
              title: 'OMI Algorithm',
              description: 'Occlusive Myocardial Infarction diagnosis and PCI decision support',
              icon: Icons.favorite_border,
              color: const Color.fromARGB(255, 229, 57, 53),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OMIAlgorithmPage()),
              ),
            ),_AlgorithmCard(
              title: 'OMI Algorithm 2',
              description: 'Occlusive Myocardial Infarction diagnosis and PCI decision support',
              icon: Icons.favorite_border,
              color: const Color.fromARGB(255, 229, 57, 53),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OMIAlgorithmPage2()),
              ),
            ),
        _AlgorithmCard(
          title: 'Trauma Assessment',
          description: 'Primary and secondary survey guidelines with real-time documentation',
          icon: Icons.emergency,
          color: Colors.orange,
          comingSoon: true,
        ),
        const SizedBox(height: 12),
        const _AlgorithmCard(title: "Head Trauma Assesment", description: "Assess and manage head trauma", icon: Icons.psychology, color: Color.fromARGB(255, 22, 83, 53), comingSoon: true,),
        const SizedBox(height: 12),
        _AlgorithmCard(
          title: 'Stroke Protocol',
          description: 'Acute stroke assessment and management timeline',
          icon: Icons.psychology,
          color: Colors.purple,
          comingSoon: true,
        ),
      ],
    );
  }

  Widget _buildInternalMedicineAlgorithms(BuildContext context) {
    return Column(
      children: [
         
            
        _AlgorithmCard(
          title: 'Hypertension Management',
          description: 'Step-wise approach to hypertension management',
          icon: Icons.favorite,
          color: Colors.green,
          comingSoon: true,
        ),
        const SizedBox(height: 12),
        _AlgorithmCard(
          title: 'Diabetes Care',
          description: 'Comprehensive diabetes management algorithms',
          icon: Icons.bloodtype,
          color: Colors.indigo,
          comingSoon: true,
        ),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medical_information,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Clinical Decision Support',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Evidence-based algorithms to support your clinical practice',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlgorithmCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool comingSoon;

  const _AlgorithmCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: comingSoon ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (comingSoon)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Coming Soon',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.amber[900],
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}