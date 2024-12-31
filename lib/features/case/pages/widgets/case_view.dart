import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/custom_case_view_page.dart';

//  wrong design 
// convert this widget to a way you can get benefit from it when you display case detail 
// e.x hide the ddx and anloy you can see the ddx after pressing of this Widget
// 2 parameter the title and the body (the answer)
class CaseViewCard extends ConsumerStatefulWidget {
  final String caseName;
  final String author;
  final String date;
  const CaseViewCard(
      {required this.caseName,
      required this.author,
      required this.date,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CaseViewCardState();
}

class _CaseViewCardState extends ConsumerState<CaseViewCard> {
  bool active = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          active = !active;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Color.fromARGB(255, 60, 26, 70),
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.caseName,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("By: ${widget.author}"), Text(widget.date)],
            ),
          ),
          isExpanded: active,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}
// }
// class CaseViewCard extends ConsumerWidget {
//   final String caseName;
//   final String author;
//   final String date;
//   const CaseViewCard({required this.caseName,required this.author,required this.date, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ExpansionPanelList(

//     )
// //     Card(
// //       color: Colors.purple[500],
// //       elevation: 5,
// //       shadowColor: Colors.black,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(15),
// //       ),
// //       child: ListTile(
// //         title: Text(caseName, style: Theme.of(context).textTheme.headlineMedium,),
// //         subtitle: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text("By: $author"),
// // Text(date)
// //           ],
// //         ),
// //       ),
// //     );
//   }
// }

// Widget buildCaseItem(MyCase myCase, BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//     child: ExpansionTileCard(
//       baseColor: AppPallete.greyColor,
//       expandedColor: AppPallete.backgroundColor.withOpacity(0.1),
//       elevation: 2,
//       leading: CircleAvatar(
//         backgroundColor: AppPallete.gradient2.withOpacity(0.2),
//         child: Icon(
//           Icons.medical_services_outlined,
//           color: AppPallete.gradient2,
//         ),
//       ),
//       title: Text(
//         myCase.case_name,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppPallete.gradient2, // Changed from gradient1 to gradient2
//         ),
//       ),
//       subtitle: Row(
//         children: [
//           Text(
//             "By: ${myCase.name}",
//             style: TextStyle(
//               color: AppPallete.backgroundColor.withOpacity(0.7),
//               fontSize: 13,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             DateFormat("dd-MMM-yyyy").format(DateTime.parse(myCase.created_at)),
//             style: TextStyle(
//               color: AppPallete.backgroundColor.withOpacity(0.6),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Divider(height: 1, color: AppPallete.borderColor),
//               const SizedBox(height: 12),
//               if (myCase.caseInfo != null) ...[
//                 _buildInfoSection('Investigation Data:', myCase.caseIvx!.inv_data),
//                 _buildInfoSection('Diagnosis:', myCase.caseInfo!.illness_hx),
//                 _buildInfoSection('Treatment:', myCase.caseInfo!.management_plan),
//               ],
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // TextButton.icon(
//                   //   icon: const Icon(
//                   //     Icons.edit_outlined,
//                   //     color: AppPallete.gradient2,
//                   //     size: 20,
//                   //   ),
//                   //   label: const Text(
//                   //     'Edit',
//                   //     style: TextStyle(color: AppPallete.gradient2),
//                   //   ),
//                   //   onPressed: () {
//                   //     // Handle edit
//                   //   },
//                   // ),
//                   const SizedBox(width: 8),
//                   TextButton.icon(
//                     icon: const Icon(
//                       Icons.visibility_outlined,
//                       color: AppPallete.whiteColor, // Changed to white for dark theme
//                       size: 20,
//                     ),
//                     label: const Text(
//                       'View Details',
//                       style: TextStyle(
//                         color: AppPallete.whiteColor, // Changed to white for dark theme
//                         fontSize: 14,
//                       ),
//                     ),
//                     onPressed: () {
//                       // Navigate to case details page
//                       GoRouter.of(context).goNamed(
//                         'view_case',
//                         extra: {
//                           'myCase': myCase,
//                           'caseInfo': myCase.caseInfo,
//                           'caseIvx': myCase.caseIvx,
//                         },
//                       );

//                     },
//                     style: TextButton.styleFrom(
//                       backgroundColor: AppPallete.gradient1.withOpacity(0.2), // Semi-transparent background
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildInfoSection(String title, String content) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: AppPallete.gradient1, // Changed from gradient2 to gradient1
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           content,
//           style: TextStyle(
//             fontSize: 14,
//             color: AppPallete.whiteColor.withOpacity(0.8), // Changed from backgroundColor to whiteColor
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget buildCaseItem(MyCase myCase, BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0), // Slightly increased padding for better spacing
//     child: ExpansionTileCard(
//       baseColor: AppPallete.greyColor.withOpacity(0.1), // Softer background for dark theme
//       expandedColor: AppPallete.backgroundColor.withOpacity(0.15), // Slight transparency for expanded state
//       elevation: 3,
//       shadowColor: Colors.black.withOpacity(0.3), // Subtle shadow for a floating effect
//       leading: CircleAvatar(
//         backgroundColor: AppPallete.gradient2.withOpacity(0.25), // Softer background in the avatar
//         child: Icon(
//           Icons.medical_services_outlined,
//           color: AppPallete.gradient2,
//         ),
//       ),
//       title: Text(
//         myCase.case_name,
//         style: const TextStyle(
//           fontSize: 17,
//           fontWeight: FontWeight.bold,
//           color: AppPallete.gradient2, // Accent color for better visibility in dark theme
//         ),
//       ),
//       subtitle: Row(
//         children: [
//           Text(
//             "By: ${myCase.name}",
//             style: TextStyle(
//               color: AppPallete.whiteColor.withOpacity(0.7), // Adjusted to lighter tone for dark background
//               fontSize: 13,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             DateFormat("dd-MMM-yyyy").format(DateTime.parse(myCase.created_at)),
//             style: TextStyle(
//               color: AppPallete.whiteColor.withOpacity(0.6), // Subtle contrast for date text
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Divider(height: 1, color: AppPallete.borderColor), // Consistent divider
//               const SizedBox(height: 12),
//               if (myCase.caseInfo != null) ...[
//                 _buildInfoSection('Investigation Data:', myCase.caseIvx!.inv_data),
//                 _buildInfoSection('Diagnosis:', myCase.caseInfo!.illness_hx),
//                 _buildInfoSection('Treatment:', myCase.caseInfo!.management_plan),
//               ],
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton.icon(
//                     icon: const Icon(
//                       Icons.visibility_outlined,
//                       color: AppPallete.gradient1, // Accent color on icon
//                       size: 20,
//                     ),
//                     label: const Text(
//                       'View Details',
//                       style: TextStyle(
//                         color: AppPallete.gradient1, // Matched text with icon color for consistency
//                         fontSize: 14,
//                       ),
//                     ),
//                     onPressed: () {
//                       // Navigate to case details page
//                       GoRouter.of(context).pushNamed(
//                         'view_case',
//                         extra: {
//                           'myCase': myCase,
//                           'caseInfo': myCase.caseInfo,
//                           'caseIvx': myCase.caseIvx,
//                         },
//                       );
//                     },
//                     style: TextButton.styleFrom(
//                       backgroundColor: AppPallete.gradient1.withOpacity(0.15), // Subtle background color for dark theme
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildInfoSection(String title, String content) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: AppPallete.gradient1, // Accent color for section headers
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           content,
//           style: TextStyle(
//             fontSize: 14,
//             color: AppPallete.whiteColor.withOpacity(0.85), // Lighter text for readability on dark background
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget buildCaseItem(MyCase myCase, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0, right: 8.0, left: 8.0),
    child: Card(
      // elevation: 5,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        // padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    
                    // boxShadow:[
                    //   BoxShadow(
                    //     blurRadius: 1,
                    //     color: AppPallete.gradient1.withOpacity(0.1),
                    //     spreadRadius: 0.3
                    //   )
                    // ] ,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.1),
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),),
        child: ExpansionTileCard(
          // initialElevation: 5,
            baseColor: Colors.transparent,
            // elevationCurve: Curves.easeInOut,
            expandedColor: AppPallete.backgroundColor,
            // elevation: 5,
            borderRadius: BorderRadius.circular(12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPallete.gradient1.withOpacity(0.2),
                    AppPallete.gradient2.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            
              child: const Icon(
                Icons.medical_services_rounded,
                color: AppPallete.gradient1,
                size: 24,
              ),
            ),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      myCase.case_name.capitalize(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppPallete.whiteColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppPallete.whiteColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        myCase.name!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppPallete.whiteColor.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppPallete.whiteColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat("MMM dd, yyyy").format(DateTime.parse(myCase.created_at)),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppPallete.whiteColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppPallete.gradient1.withOpacity(0.05),
                      AppPallete.gradient2.withOpacity(0.02),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myCase.structured == false ?  Container(
                        child: Text("${Document.fromJson(jsonDecode(myCase.case_detail!)).toPlainText().substring(0,100).capitalize()} ...", style: TextStyle(color: AppPallete.whiteColor),),
                      ) : Column(
                        children: [
                          _buildInfoSection(
                        'Investigation',
                        myCase.caseIvx?.inv_data ?? '',
                        Icons.science_outlined,
                      ),
                      _buildInfoSection(
                        'Diagnosis',
                        myCase.caseInfo?.followup_notes ?? '',
                        Icons.medical_information_outlined,
                      ),
                      _buildInfoSection(
                        'Treatment',
                        myCase.caseInfo?.management_plan ?? '',
                        Icons.healing_outlined,
                      ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          onPressed: (){
                            if (myCase.structured == false) {
                               Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                                return CustomCaseViewPage(myCase: myCase);
                              },));
                              return;
                            }
                            context.pushNamed(
                            "view_case",
                            extra: {'myCase': myCase,
                            'caseInfo': myCase.caseInfo,
                            'caseIvx': myCase.caseIvx},
                          );
          
                          },
                          color: AppPallete.gradient1.withOpacity(0.1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: AppPallete.gradient1.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.visibility_outlined,
                                  color: AppPallete.whiteColor,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    color: AppPallete.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    ),
  );
     }

Widget _buildInfoSection(String title, String content, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppPallete.gradient1,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppPallete.gradient1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppPallete.whiteColor.withOpacity(0.8),
          ),
        ),
      ],
    ),
  );
}