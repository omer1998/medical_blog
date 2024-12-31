import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';

import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/add_custom_case_page.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_editor.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_seg_title.dart';
import 'package:medical_blog_app/features/case/pages/widgets/cases_list.dart';
import 'package:medical_blog_app/features/case/pages/widgets/topic_tags.dart';
import 'package:uuid/uuid.dart';


class AddCasePage extends ConsumerStatefulWidget {
  final String userId;
  const AddCasePage({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCasePageState();
}

class _AddCasePageState extends ConsumerState<AddCasePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _historyFormKey = GlobalKey<FormState>();
  final _physicalFormKey = GlobalKey<FormState>();
  final _investigationFormKey = GlobalKey<FormState>();
  final _managementFormKey = GlobalKey<FormState>();
  late final PageController _pageController;
  late final ValueNotifier<double> _progressNotifier;

  // Case sections controllers
  final Map<String, TextEditingController> _controllers = {
    'caseName': TextEditingController(),
    'demographics': TextEditingController(),
    'chiefComplaint': TextEditingController(),
    'historyOfIllness': TextEditingController(),
    'reviewOfSystems': TextEditingController(),
    'medications': TextEditingController(),
    'pastMedical': TextEditingController(),
    'pastSurgical': TextEditingController(),
    'familyHistory': TextEditingController(),
    'physicalExam': TextEditingController(),
    'vitalSigns': TextEditingController(),
    'investigations': TextEditingController(),
    'diagnosis': TextEditingController(),
    'management': TextEditingController(),
    'followUp': TextEditingController(),
  };

  final List<String> _sections = [
    'Basic Info',
    'History',
    'Physical Exam',
    'Investigation',
    'Management'
  ];

  int _currentSection = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressNotifier = ValueNotifier(0.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressNotifier.dispose();
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
  Widget buildProgressIndicator() {
  return PreferredSize(
            preferredSize: Size.fromHeight(6.0),
            child: ValueListenableBuilder<double>(
              valueListenable: _progressNotifier,
              builder: (context, progress, _) => LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('New Case'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Structured'),
              Tab(text: 'Custom'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStructuredcase(),
           const AddCustomCasePage(),
          ],
        ),
        
      ),
    );
  }

  
 Widget _buildStructuredcase(){
    return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _currentSection > 0
                        ? () => _navigateToSection(_currentSection - 1)
                        : null,
                  ),
                  Text(
                    _sections[_currentSection],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _currentSection < _sections.length - 1
                        ? () => _navigateToSection(_currentSection + 1)
                        : null,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentSection = index);
                  _progressNotifier.value = (index + 1) / _sections.length;
                },
                children: [
                  _buildBasicInfoSection(),
                  _buildHistorySection(),
                  _buildPhysicalExamSection(),
                  _buildInvestigationSection(),
                  _buildManagementSection(),
                ],
              ),
            ),
             _buildBottomBar()
          ],
        );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentSection > 0)
              TextButton(
                onPressed: () => _navigateToSection(_currentSection - 1),
                child: Text('Previous'),
              )
            else
              SizedBox(width: 80),
            Text(
              '${_currentSection + 1}/${_sections.length}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (_currentSection < _sections.length - 1)
              FilledButton(
                onPressed: () => _navigateToSection(_currentSection + 1),
                child: Text('Next'),
              )
            else
              FilledButton(
                onPressed: _isSubmitting ? null : () => _submitCase(widget.userId),
                child: _isSubmitting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToSection(int index) {
    // When moving forward, validate current section
    print("tags: ${ref.read(selectedTagsProvider.notifier).state}");
    if (index > _currentSection) {
      final currentFormKey = _getCurrentFormKey();
      if (currentFormKey?.currentState == null || !currentFormKey!.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please complete all required fields in ${_sections[_currentSection]} section'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      // Check for topic tags in the first section
      if (_currentSection == 0 && ref.read(selectedTagsProvider).isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select at least one topic tag'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }
    
    setState(() {
      _currentSection = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submitCase(String authorId) async {
    // Validate current section first
    final currentFormKey = _getCurrentFormKey();
    if (currentFormKey?.currentState == null || !currentFormKey!.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all required fields in ${_sections[_currentSection]} section'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Validate topic tags only when submitting
    if (ref.read(selectedTagsProvider).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one topic tag'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      _navigateToSection(0);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      print("tags: ${ref.read(selectedTagsProvider.notifier).state}");
      final myCase = Case(
        id: const Uuid().v4(),
        caseName: _controllers['caseName']?.text.trim() ?? '',
        caseAuthorId: authorId,
        demographicData: _controllers['demographics']?.text.trim() ?? '',
        cheifComplain: _controllers['chiefComplaint']?.text.trim() ?? '',
        illnessHx: _controllers['historyOfIllness']?.text.trim() ?? '',
        reviewHx: _controllers['reviewOfSystems']?.text.trim() ?? '',
        medsHx: _controllers['medications']?.text.trim() ?? '',
        pmh: _controllers['pastMedical']?.text.trim() ?? '',
        psh: _controllers['pastSurgical']?.text.trim() ?? '',
        familyHx: _controllers['familyHistory']?.text.trim() ?? '',
        physicalExam: _controllers['physicalExam']?.text.trim() ?? '',
        vitalSigns: _controllers['vitalSigns']?.text.trim() ?? '',
        followUpNotes: _controllers['followUp']?.text.trim() ?? '',
        managementPlan: _controllers['management']?.text.trim() ?? '',
        ddx: _controllers['diagnosis']?.text.trim() ?? '',
        ivx: _controllers['investigations']?.text.trim() ?? '',
        tags: ref.read(selectedTagsProvider.notifier).state,
      );

      print("this case: ${myCase.toMap()}");

      await ref.read(caseControllerProvider).addCase(context, myCase);
      ref.read(selectedTagsProvider.notifier).state = [];
      ref.refresh(getCasesProvider);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Case submitted successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      
      Navigator.of(context).pop();
    } catch (e) {
      ref.read(selectedTagsProvider.notifier).state = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting case: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // Helper method to get the current form's key
  GlobalKey<FormState>? _getCurrentFormKey() {
    switch (_currentSection) {
      case 0:
        return _formKey;
      case 1:
        return _historyFormKey;
      case 2:
        return _physicalFormKey;
      case 3:
        return _investigationFormKey;
      case 4:
        return _managementFormKey;
      default:
        return null;
    }
  }

  Widget _buildBasicInfoSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaseEditor(
                controller: _controllers['caseName']!, 
                hintText: 'Case Name',
                require: true,
              ),
              CaseEditor(
                controller: _controllers['demographics']!, 
                hintText: 'Demographics',
                require: true,
              ),
              TopicTags(
                tags: [
                  "Respiratory",
                  "Cardiology",
                  "Nephrology",
                  "CNS",
                  "Gastrointestinal",
                  "Endocrinology",
                  "Hematology",
                  "Infectious Disease",
                  "Musculoskeletal",
                  "Psychiatry",
                  "Rheumatology",
                  "Urology"
                ], 
                onSelected: (tags) {
                  ref.read(selectedTagsProvider.notifier).state = tags;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _historyFormKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaseEditor(
                controller: _controllers['chiefComplaint']!, 
                hintText: 'Chief Complaint',
                require: true,
                minLine: 2,
              ),
              CaseEditor(
                controller: _controllers['historyOfIllness']!, 
                hintText: 'History of Present Illness',
                require: true,
                minLine: 3,
              ),
              CaseEditor(
                controller: _controllers['reviewOfSystems']!, 
                hintText: 'Review of Systems',
                require: true,
                minLine: 3,
              ),
              CaseEditor(
                controller: _controllers['medications']!, 
                hintText: 'Current Medications',
                require: false,
                minLine: 2,
              ),
              CaseEditor(
                controller: _controllers['pastMedical']!, 
                hintText: 'Past Medical History',
                require: false,
                minLine: 2,
              ),
              CaseEditor(
                controller: _controllers['pastSurgical']!, 
                hintText: 'Past Surgical History',
                require: false,
                minLine: 2,
              ),
              CaseEditor(
                controller: _controllers['familyHistory']!, 
                hintText: 'Family History',
                require: false,
                minLine: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhysicalExamSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _physicalFormKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaseEditor(
                controller: _controllers['physicalExam']!, 
                hintText: 'Physical Examination',
                require: true,
                minLine: 4,
              ),
              CaseEditor(
                controller: _controllers['vitalSigns']!, 
                hintText: 'Vital Signs',
                require: true,
                minLine: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvestigationSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _investigationFormKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaseEditor(
                controller: _controllers['investigations']!, 
                hintText: 'Investigations',
                require: true,
                minLine: 4,
              ),
              // TODO: Add image upload functionality
              const SizedBox(height: 16),
              Text(
                'Upload Images',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Center(
                child: IconButton.filled(
                  onPressed: () {
                    // TODO: Implement image upload
                  }, 
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _managementFormKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaseEditor(
                controller: _controllers['diagnosis']!, 
                hintText: 'Differential Diagnosis',
                require: true,
                minLine: 3,
              ),
              CaseEditor(
                controller: _controllers['management']!, 
                hintText: 'Management Plan',
                require: true,
                minLine: 4,
              ),
              CaseEditor(
                controller: _controllers['followUp']!, 
                hintText: 'Follow Up Notes',
                require: false,
                minLine: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

