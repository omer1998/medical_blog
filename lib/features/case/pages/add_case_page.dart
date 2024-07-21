import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';

import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_editor.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_seg_title.dart';
import 'package:medical_blog_app/features/case/pages/widgets/topic_chips_grid.dart';
import 'package:uuid/uuid.dart';

class AddCasePage extends ConsumerStatefulWidget {
  const AddCasePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCasePageState();
}

class _AddCasePageState extends ConsumerState<AddCasePage>
    with SingleTickerProviderStateMixin {
  QuillController _controller = QuillController.basic();
  TextEditingController nameController = TextEditingController();
  TextEditingController demographController = TextEditingController();
  TextEditingController ccController = TextEditingController();
  TextEditingController hxOfIllnessController = TextEditingController();
  TextEditingController reviewOfSystemController = TextEditingController();
  TextEditingController medController = TextEditingController();
  TextEditingController pmhController = TextEditingController();
  TextEditingController pshController = TextEditingController();
  TextEditingController familyHxController = TextEditingController();
  TextEditingController physicExamController = TextEditingController();
  TextEditingController vitalSignController = TextEditingController();
  TextEditingController invxController = TextEditingController();
  TextEditingController managementController = TextEditingController();
  TextEditingController ddxController = TextEditingController();
  TextEditingController followUpController = TextEditingController();

  TextEditingController customCaseNameController = TextEditingController();
  QuillController customCaseDetailsController = QuillController.basic();

  final detailFormKey = GlobalKey<FormState>();
  final invxFormKey = GlobalKey<FormState>();
  final managementFormKey = GlobalKey<FormState>();
  int _currentStep = 0;
  late Case currentCase;
  late final tabController;
  final FocusNode detailFocus = FocusNode();
  bool focused = false;

  List<String> topicTags = [
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
  ];

  @override
  void initState() {
    tabController = TabController(
      vsync: this,
      length: 2,
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    detailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state;
    String _authorId = (state as UserLoggedInState).user.id;

    final stepLists = [
      caseDetailForm(),
      caseIvx(),
      caseManagement(),
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Case'),
          bottom: TabBar(
            labelColor: Colors.amber,
            indicatorColor: Colors.amber,
            labelPadding: EdgeInsets.all(8),
            controller: tabController,
            tabs: [
              Text(
                "Structured",
                style: TextStyle(fontSize: 20),
              ),
              Text("Custom", style: TextStyle(fontSize: 20))
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            steps(_authorId, stepLists),
            customFormCase(),
          ],
        ));
  }

  customFormCase() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Custom Form"),
              // Add custom form fields here
              TopicTags(tags: topicTags),

              CaseSegmentTitle(title: "Case Title"),
              CaseEditor(
                  controller: customCaseNameController,
                  hintText: "Enter the name of this case"),
              SizedBox(
                height: 10,
              ),
              CaseSegmentTitle(title: "Case Details"),
              QuillToolbar.simple(
                  configurations: QuillSimpleToolbarConfigurations(
                      axis: Axis.horizontal,
                      multiRowsDisplay: false,
                      controller: customCaseDetailsController)),
              SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: focused
                          ? AppPallete.gradient2
                          : AppPallete.borderColor,
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: QuillEditor(
                      configurations: QuillEditorConfigurations(
                        // maxHeight: 350,
                        
                          autoFocus: true,
                          expands: true,
                          scrollable: true,
                          placeholder: "Enter your case details HERE .... ",
                          controller: customCaseDetailsController),
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child:
                      ElevatedButton(onPressed: () {}, child: Text("Submit")))
            ],
          ),
        ),
      ),
    );
  }

  Widget steps(String authorId, List<dynamic> stepLists) {
    return Stepper(
      controlsBuilder: (context, details) {
        return Row(
          children: [
            if (_currentStep != 0)
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('Back'),
              ),
            if (_currentStep != 2)
              TextButton(
                onPressed: details.onStepContinue,
                child: const Text('Next'),
              ),
            if (_currentStep == 2)
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
                onPressed: details.onStepContinue,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
          ],
        );
      },
      currentStep: _currentStep,
      onStepTapped: (step) {
        // setState(() {
        //   _currentStep = step;
        // });
      },
      onStepContinue: () {
        if (_currentStep == 0) {
          if (detailFormKey.currentState!.validate()) {
            // update case model with current controller data
            currentCase = Case(
                id: const Uuid().v4(),
                caseName: nameController.text.trim(),
                caseAuthorId: authorId,
                demographicData: demographController.text.trim(),
                cheifComplain: ccController.text.trim(),
                illnessHx: hxOfIllnessController.text.trim(),
                reviewHx: reviewOfSystemController.text.trim(),
                medsHx: medController.text.trim(),
                pmh: pmhController.text.trim(),
                psh: pshController.text.trim(),
                familyHx: familyHxController.text.trim(),
                physicalExam: physicExamController.text.trim(),
                vitalSigns: vitalSignController.text.trim(),
                followUpNotes: "",
                managementPlan: "",
                ddx: "");

            setState(() {
              _currentStep++;
            });
          }
        }
        if (_currentStep == 1) {
          if (invxFormKey.currentState!.validate()) {
            // update case model with current controller data Investigation
            currentCase = currentCase.copyWith(ivx: invxController.text.trim());

            setState(() {
              _currentStep++;
            });
          }
        }
        if (_currentStep == 2) {
          if (managementFormKey.currentState!.validate()) {
            // update case model with current controller data

            currentCase = currentCase.copyWith(
                managementPlan: managementController.text.trim(),
                ddx: ddxController.text.trim(),
                followUpNotes: followUpController.text.trim());
            print("case info is --");
            print(currentCase.toMap());
            // submit data to supabase
            ref.read(caseControllerProvider).addCase(context, currentCase);
            ref.refresh(getCasesProvider);
          }
        }
      },
      onStepCancel: () {
        if (_currentStep == 0) {
          return;
        }
        setState(() {
          _currentStep--;
        });
      },
      type: StepperType.vertical,
      steps: [
        Step(
          title: Text("Case Details"),
          content: stepLists[0],
        ),
        Step(
          title: Text("Investigation"),
          content: stepLists[1],
        ),
        Step(
          title: Text("Management Plan"),
          content: stepLists[2],
        ),
      ],
    );
  }

  caseIvx() {
    // case ivx
    return Form(
      key: invxFormKey,
      child: Column(
        children: [
          CaseEditor(
            controller: invxController,
            hintText: "Investigations",
            minLine: 3,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Upload Images"),
          IconButton.filled(onPressed: () {}, icon: Icon(Icons.add)),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  caseManagement() {
    // management plan
    return Form(
      key: managementFormKey,
      child: Column(
        children: [
          Align(
            child: Text("Differntial Diagnosis"),
            alignment: Alignment.centerLeft,
          ),
          CaseEditor(
            controller: ddxController,
            hintText: "Differntial Diagnosis",
            minLine: 2,
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text("Management Plan"),
            alignment: Alignment.centerLeft,
          ),
          CaseEditor(
            controller: managementController,
            hintText: "enter detailed management",
            minLine: 5,
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text("Follow Up Notes"),
            alignment: Alignment.centerLeft,
          ),
          CaseEditor(
            controller: followUpController,
            hintText: "Enter follow up notes here..",
            minLine: 3,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget caseDetailForm() {
    return Form(
      key: detailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // QuillToolbar.simple(
          //   configurations: QuillSimpleToolbarConfigurations(
          //     multiRowsDisplay: false,
          //     controller: _controller,
          //     sharedConfigurations: const QuillSharedConfigurations(
          //       locale: Locale('de'),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              child: Text(
                "Enter Case Details",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              alignment: Alignment.center,
            ),
          ),
          CaseEditor(controller: nameController, hintText: "Case Name"),
          CaseEditor(
              controller: demographController, hintText: "Demographic Data"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Main HX",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          CaseEditor(controller: ccController, hintText: "Cheif Complain"),
          CaseEditor(
              controller: hxOfIllnessController,
              hintText: "Hx of present illness"),
          CaseEditor(
              controller: reviewOfSystemController,
              hintText: "Review of system"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Other HX",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          CaseEditor(controller: medController, hintText: "Medication History"),
          CaseEditor(
              controller: pmhController, hintText: "Past medical history"),
          CaseEditor(
              controller: pshController, hintText: "Past surgical history"),
          CaseEditor(
              controller: familyHxController, hintText: "Family History"),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Physical Examination",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          CaseEditor(
              controller: physicExamController,
              hintText: "Physical Examination"),
          CaseEditor(controller: vitalSignController, hintText: "Vital Signs"),
          // QuillEditor.basic(
          //   configurations: QuillEditorConfigurations(
          //     controller: _controller,
          //     placeholder: "Case name",
          //     padding: EdgeInsets.all(12),
          //     sharedConfigurations: const QuillSharedConfigurations(
          //       locale: Locale('en'),
          //     ),
          //   ),
          // )

          // Align(
          //   alignment: Alignment.center,
          //   child: ElevatedButton(style: ElevatedButton.styleFrom(
          //     backgroundColor: AppPallete.gradient1,

          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          //     onPressed: (){}, child: Text("Submit", style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          //   ),)),
        ],
      ),
    );
  }
}
