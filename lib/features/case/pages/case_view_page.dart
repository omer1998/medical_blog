import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_seg_title.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_text.dart';
class CaseViewPage extends StatefulWidget {
  final MyCase myCase;
  final CaseInfo caseInfo;
  final CaseIvx caseIvx;
  const CaseViewPage({super.key, required this.myCase, required this.caseInfo, required this.caseIvx});

  @override
  State<CaseViewPage> createState() => _CaseViewPageState();
}

class _CaseViewPageState extends State<CaseViewPage> {
  
late ExpansionTileController hxController;
late ExpansionTileController examController;
late ExpansionTileController ivxController;
late ExpansionTileController managementController;
late ExpansionTileController followController;

bool hxTileState = false;
bool examTileState = false;
bool ivxTileState = false;
bool managementTileState = false;
bool followTileState = false;

onExpansion(ExpansionTileController main, bool state){
  List<ExpansionTileController> controllers = [hxController, examController, ivxController, managementController, followController];
  if (state == true) {
    controllers.forEach((element) {
      if (element != main) {
        element.collapse();
      }
    });
  }

}

changeTileState (bool state, ExpansionTileController controller){
  if (state) {
    controller.collapse();
  } else {
    controller.expand();
  }

}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  hxController = ExpansionTileController();
  examController = ExpansionTileController();
  ivxController = ExpansionTileController();
  managementController = ExpansionTileController();
  followController = ExpansionTileController();
 
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
       


    return Scaffold(
      appBar: AppBar(
        title: Text("Case View"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            CaseText(text: widget.myCase.case_name.capitalize()),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Chip(
                      backgroundColor: Colors.grey,
                      side: BorderSide.none,
                      clipBehavior: Clip.antiAlias,
                      label: Text(
                        "Respiratory",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "By ${widget.myCase.name}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${DateFormat("d MMM y").format(DateTime.parse(widget.myCase.created_at))}"),
                ),
              ],
            ),
            Divider(
              height: 2,
              thickness: 2,
              // indent: 20,
              // endIndent: 20,
            ),
            InkWell(
              onTap: (){
                changeTileState(hxTileState, hxController);
              },
              child: ExpansionTile(
                
                controller: hxController,
                onExpansionChanged: (value) {
                hxTileState = value;
                  onExpansion(hxController, value);
                },
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                title: Text(
                  "History",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                children: [
                  // CaseSegmentText(title: "Demographic Data", text: caseInfo.demographic_data),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CaseSegmentTitle(title: "Demographis data"),
                        Text(widget.caseInfo.demographic_data),
                        SizedBox(height: 10),
                        CaseSegmentTitle(title: "Chief Complain"),
                        Text(widget.caseInfo.cheif_complain),
                        SizedBox(height: 10),
                        CaseSegmentTitle(title: "History of Present illness"),
                        Text(widget.caseInfo.illness_hx),
                  
                  
                        SizedBox(height: 10),
                        CaseSegmentTitle(title: "Review of System"),
                        Text(widget.caseInfo.review_hx),
                  
                        SizedBox(height: 10,),
                        CaseSegmentTitle(title: "Medication History"),
                        Text(widget.caseInfo.meds_hx),
                  
                        
                        SizedBox(height: 10,),
                        CaseSegmentTitle(title: "Past Medical History"),
                        Text(widget.caseInfo.pmh),
                  
                        
                        SizedBox(height: 10,),
                        CaseSegmentTitle(title: "Past Surgical History"),
                        Text(widget.caseInfo.psh),
                  
                        
                        SizedBox(height: 10,),
                        CaseSegmentTitle(title: "Family History"),
                        Text(widget.caseInfo.family_hx),
                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: (){
                changeTileState(examTileState, examController);
              },
              child: ExpansionTile(
                // dense: true,
                onExpansionChanged: (value) {
                  setState(() {
                    examTileState = value;
                  });
                  onExpansion(examController, value);
                },
                
                controller: examController,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromRGBO(45, 5, 243, 1),
                collapsedBackgroundColor: Color.fromRGBO(45, 5, 243, 1),
                title: Text("Physical Examination",  
                  style: Theme.of(context).textTheme.headlineSmall,   
              ),
              expandedAlignment: Alignment.topLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaseSegmentTitle(title: "Vital Signs"),
                  Text(widget.caseInfo.vital_signs),
                  SizedBox(height: 10,),
                  
                  CaseSegmentTitle(title: "General Examination"),
                  Text(widget.caseInfo.physical_exam)
                    ],
                  ),
                )
              ],
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                changeTileState(ivxTileState, ivxController);
              },
              child: ExpansionTile(
                onExpansionChanged: (value) {
                    setState(() {
                      ivxTileState = value;
                    });
                    onExpansion(ivxController, value);
                  },
                  
                controller: ivxController,
                title: Text("Investigations", style: Theme.of(context).textTheme.headlineSmall,),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CaseSegmentTitle(title: "Lab Results"),
                        Text(widget.caseIvx.inv_data),
                        SizedBox(height: 10,),
                        CaseSegmentTitle(title: "Result Images"),
                        Text(widget.caseIvx.inv_imgs.isEmpty ? "No Images For this case" : widget.caseIvx.inv_imgs.join(", ")),
                        
                      ],
                    ),
                  )
                ],
                
              ),
            ),
            
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                changeTileState(managementTileState, managementController);
              },
              child: ExpansionTile(
                onExpansionChanged: (value) {
                      setState(() {
                        managementTileState = value;
                      });
                      onExpansion(managementController, value);
                    },
                controller: managementController,
                // childrenPadding: EdgeInsets.all(10),
                title: Text("Management Plan", style: Theme.of(context).textTheme.headlineSmall,),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.caseInfo.followup_notes)
                        
                      ],
                    ),
                  )
                ],
                
              ),
            ),
            SizedBox(height: 5,),
             InkWell(
              onTap: (){
                changeTileState(followTileState, followController);
              },
               child: ExpansionTile(
                onExpansionChanged: (value) {
                        setState(() {
                          followTileState = value;
                        });
                        onExpansion(followController, value);
                      },
                controller: followController,
                title: Text("Follow Up Notes", style: Theme.of(context).textTheme.headlineSmall,),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.caseInfo.followup_notes)
                        
                      ],
                    ),
                  )
                ],
                
                           ),
             ),
          ],
        ),
      ),
    );
  }
}

