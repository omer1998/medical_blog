import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/case_view_page.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_editor.dart';
import 'package:medical_blog_app/features/case/pages/widgets/topic_tags.dart';

class EditCasePage extends ConsumerStatefulWidget {
  final MyCase myCase;
  final CaseInfo caseInfo;
  final CaseIvx caseIvx;
  const EditCasePage({super.key, required this.myCase, required this.caseInfo, required this.caseIvx});

  @override
  ConsumerState<EditCasePage> createState() => _EditCasePageState();
}

class _EditCasePageState extends ConsumerState<EditCasePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  late final TextEditingController _caseNameController;
  late final TextEditingController _demographicsController;
  late final TextEditingController _chiefComplaintController;
  late final TextEditingController _historyController;
  late final TextEditingController _reviewController;
  late final TextEditingController _medicationsController;
  late final TextEditingController _pastMedicalController;
  late final TextEditingController _pastSurgicalController;
  late final TextEditingController _familyHistoryController;
  late final TextEditingController _physicalExamController;
  late final TextEditingController _vitalSignsController;
  late final TextEditingController _investigationsController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _managementController;
  late final TextEditingController _followUpController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing case data
    _caseNameController = TextEditingController(text: widget.myCase.case_name);
    _demographicsController = TextEditingController(text: widget.caseInfo.demographic_data);
    _chiefComplaintController = TextEditingController(text: widget.caseInfo.cheif_complain);
    _historyController = TextEditingController(text: widget.caseInfo.illness_hx);
    _reviewController = TextEditingController(text: widget.caseInfo.review_hx);
    _medicationsController = TextEditingController(text: widget.caseInfo.meds_hx);
    _pastMedicalController = TextEditingController(text: widget.caseInfo.pmh);
    _pastSurgicalController = TextEditingController(text: widget.caseInfo.psh);
    _familyHistoryController = TextEditingController(text: widget.caseInfo.family_hx);
    _physicalExamController = TextEditingController(text: widget.caseInfo.physical_exam);
    _vitalSignsController = TextEditingController(text: widget.caseInfo.vital_signs);
    _investigationsController = TextEditingController(text: widget.caseIvx.inv_data ?? '');
    _diagnosisController = TextEditingController(text: widget.caseInfo.ddx);
    _managementController = TextEditingController(text: widget.caseInfo.management_plan);
    _followUpController = TextEditingController(text: widget.caseInfo.followup_notes);

  
  }

  @override
  void dispose() {
    _caseNameController.dispose();
    _demographicsController.dispose();
    _chiefComplaintController.dispose();
    _historyController.dispose();
    _reviewController.dispose();
    _medicationsController.dispose();
    _pastMedicalController.dispose();
    _pastSurgicalController.dispose();
    _familyHistoryController.dispose();
    _physicalExamController.dispose();
    _vitalSignsController.dispose();
    _investigationsController.dispose();
    _diagnosisController.dispose();
    _managementController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  Future<void> _updateCase() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (ref.read(selectedTagsProvider).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one topic tag'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final Case updatedCase = Case(
        caseName: _caseNameController.text.trim(),
        demographicData: _demographicsController.text.trim(),
        cheifComplain: _chiefComplaintController.text.trim(),
        illnessHx: _historyController.text.trim(),
        reviewHx: _reviewController.text.trim(),
        medsHx: _medicationsController.text.trim(),
        pmh: _pastMedicalController.text.trim(),
        psh: _pastSurgicalController.text.trim(),
        familyHx: _familyHistoryController.text.trim(),
        physicalExam: _physicalExamController.text.trim(),
        vitalSigns: _vitalSignsController.text.trim(),
        ivx: _investigationsController.text.trim(),
        ddx: _diagnosisController.text.trim(),
        managementPlan: _managementController.text.trim(),
        followUpNotes: _followUpController.text.trim(),
        tags: ref.read(selectedTagsProvider), id: widget.myCase.id, caseAuthorId: widget.myCase.case_author,
      );

      final res = await ref.read(caseControllerProvider).updateCase(context, updatedCase);
      res.fold(
        (l) => showSnackBar(context, l.message, backgroundColor: Theme.of(context).colorScheme.error),
        (r) {
          showSnackBar(context, "Case updated successfully", backgroundColor: Theme.of(context).colorScheme.primary);
          // Refresh providers
          ref.refresh(getCasesProvider);
          //ref.refresh(getCaseByIdProvider(widget.myCase.id));
          // Pop back to case view
          Navigator.of(context)..pop()..pop();
          /* Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CaseViewPage(
                  myCase: MyCase(name: widget.myCase.name, tags: r.tags ?? [], id: r.id, case_name: r.caseName, case_author: r.caseAuthorId, created_at: widget.myCase.created_at),
                  caseIvx: CaseIvx(id: r.id, inv_data: r.ivx ?? "", inv_imgs: []),
                  caseInfo:CaseInfo(demographic_data: r.demographicData, cheif_complain: r.cheifComplain, illness_hx: r.illnessHx, review_hx: r.reviewHx, meds_hx: r.medsHx, pmh: r.pmh, psh: r.psh, family_hx: r.familyHx, physical_exam: r.physicalExam, vital_signs: r.vitalSigns, followup_notes: r.followUpNotes, ddx: r.ddx, management_plan: r.managementPlan),),
              ),
            ); */
          if (!mounted) {
            
          }
        }
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating case: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Case'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isSubmitting ? null : _updateCase,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CaseEditor(
                  controller: _caseNameController,
                  hintText: 'Case Name',
                  require: true,
                ),
                CaseEditor(
                  controller: _demographicsController,
                  hintText: 'Demographics',
                  require: true,
                ),
                TopicTags(
                  tags:[...ref.read(getCasesTagsProvider.notifier).state, 
                  "Respiratory",
                  "Cardiology",
                  "Nephrology",
                  "CNS",
                  "Gastrointestinal",
                  "Endocrinology",
                  "Hematology",
                  "Infectious Disease",
                  "Musculoskeletal",
                  "Neurology",
                  "Oncology",
                  "Pulmonary",
                  "Rheumatology",
                  "Surgery",
                  "Urology"
                  ].toSet().toList(),
                
                  onSelected: (tags) {
                    ref.read(selectedTagsProvider.notifier).state = tags ;
                  },
                ),
                CaseEditor(
                  controller: _chiefComplaintController,
                  hintText: 'Chief Complaint',
                  require: true,
                  minLine: 2,
                ),
                CaseEditor(
                  controller: _historyController,
                  hintText: 'History of Present Illness',
                  require: true,
                  minLine: 3,
                ),
                CaseEditor(
                  controller: _reviewController,
                  hintText: 'Review of Systems',
                  require: true,
                  minLine: 3,
                ),
                CaseEditor(
                  controller: _medicationsController,
                  hintText: 'Current Medications',
                  require: false,
                  minLine: 2,
                ),
                CaseEditor(
                  controller: _pastMedicalController,
                  hintText: 'Past Medical History',
                  require: false,
                  minLine: 2,
                ),
                CaseEditor(
                  controller: _pastSurgicalController,
                  hintText: 'Past Surgical History',
                  require: false,
                  minLine: 2,
                ),
                CaseEditor(
                  controller: _familyHistoryController,
                  hintText: 'Family History',
                  require: false,
                  minLine: 2,
                ),
                CaseEditor(
                  controller: _physicalExamController,
                  hintText: 'Physical Examination',
                  require: true,
                  minLine: 4,
                ),
                CaseEditor(
                  controller: _vitalSignsController,
                  hintText: 'Vital Signs',
                  require: true,
                  minLine: 2,
                ),
                CaseEditor(
                  controller: _investigationsController,
                  hintText: 'Investigations',
                  require: true,
                  minLine: 4,
                ),
                CaseEditor(
                  controller: _diagnosisController,
                  hintText: 'Diagnosis',
                  require: true,
                  minLine: 3,
                ),
                CaseEditor(
                  controller: _managementController,
                  hintText: 'Management Plan',
                  require: true,
                  minLine: 4,
                ),
                CaseEditor(
                  controller: _followUpController,
                  hintText: 'Follow-up Notes',
                  require: false,
                  minLine: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
