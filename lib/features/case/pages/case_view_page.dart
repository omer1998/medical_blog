import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_section.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_seg_title.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/features/case/pages/edit_case_page.dart';

class CaseViewPage extends ConsumerStatefulWidget {
  final MyCase myCase;
  final CaseInfo caseInfo;
  final CaseIvx caseIvx;
  
  const CaseViewPage({
    super.key,
    required this.myCase,
    required this.caseInfo,
    required this.caseIvx,
  });

  @override
  ConsumerState<CaseViewPage> createState() => _CaseViewPageState();
}

class _CaseViewPageState extends ConsumerState<CaseViewPage> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myCase = widget.myCase;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Case View"),
        centerTitle: true,
        actions: [
          BlocBuilder<AppUserCubit, AppUserState>(
            builder: (context, state) {
              if (state is UserLoggedInState && 
                  state.user.id == myCase.case_author) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    ref.read(selectedTagsProvider.notifier).state = myCase.tags ?? [];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCasePage(
                          myCase: myCase,
                          caseInfo: myCase.caseInfo!,
                          caseIvx: myCase.caseIvx!,
                        ),
                      ),
                    );
                    
                    
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myCase.case_name.capitalize(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          myCase.name![0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myCase.name!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM d, yyyy').format(DateTime.parse(myCase.created_at ?? DateTime.now().toIso8601String())),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (myCase.tags != null && myCase.tags!.isNotEmpty) ...[
                    Text(
                      'Topics',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: myCase.tags!.map((tag) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
                            side: BorderSide.none,
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            avatar: Icon(
                              Icons.local_offer_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text(tag),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CaseSection(
                    title: "History",
                    icon: Icons.history_edu,
                    children: [
                      _buildHistorySection("Demographics", widget.caseInfo.demographic_data),
                      _buildHistorySection("Chief Complaint", widget.caseInfo.cheif_complain),
                      _buildHistorySection("Present Illness", widget.caseInfo.illness_hx),
                      _buildHistorySection("Review of Systems", widget.caseInfo.review_hx),
                      _buildHistorySection("Medications", widget.caseInfo.meds_hx),
                      _buildHistorySection("Past Medical History", widget.caseInfo.pmh),
                      _buildHistorySection("Past Surgical History", widget.caseInfo.psh),
                      _buildHistorySection("Family History", widget.caseInfo.family_hx),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CaseSection(
                    title: "Physical Examination",
                    icon: Icons.medical_services,
                    children: [
                      _buildHistorySection("Physical Exam", widget.caseInfo.physical_exam),
                      _buildHistorySection("Vital Signs", widget.caseInfo.vital_signs),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CaseSection(
                    title: "Investigation",
                    icon: Icons.science,
                    children: [
                      _buildHistorySection("Investigation Data", widget.caseIvx.inv_data),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CaseSection(
                    title: "Management",
                    icon: Icons.healing,
                    children: [
                      _buildHistorySection("Management Plan", widget.caseInfo.management_plan),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CaseSection(
                    title: "Follow Up",
                    icon: Icons.event_note,
                    children: [
                      _buildHistorySection("Follow Up Notes", widget.caseInfo.followup_notes),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
