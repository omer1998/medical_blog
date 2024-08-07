import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/utils/extensions.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';

final selectedCasesProvider = StateProvider<List<MyCase>?>((ref) {
  return ;
});


class CasesList extends StatelessWidget {
  final List<MyCase> cases;
  const CasesList({required this.cases, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                      itemCount: cases.length,
                      itemBuilder: (context, index) {
                        // print("item count is --> ${cases.length}");
                        // print(cases[index]["tags"]);
                        final myCase = cases[index];
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                                leading: Icon(Icons.blur_linear),
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                title: Text(
                                  myCase.case_name.capitalize(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "by ${myCase.name}" ?? "unKnown author"),
                                backgroundColor:
                                    const Color.fromARGB(255, 58, 4, 27),
                                collapsedBackgroundColor:
                                    const Color.fromARGB(255, 76, 3, 96),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                children: [
                                  const Divider(
                                    thickness: 1.0,
                                    height: 1.0,
                                  ),
                                  // Text(cases[index]['cases_infos'][0]["cheif_complain"]as String),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: myCase.tags !=
                                                    null
                                                ? myCase.tags!
                                                    .map((tag) {
                                                    // print("case tags");
                                                    // print(cases[index]["tags"]);
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Chip(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          side: BorderSide.none,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          label: Text(
                                                            tag,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )),
                                                    );
                                                  }).toList()
                                                : [Container()],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Created On: ${DateFormat('d MMM y').format(DateTime.parse(myCase.created_at))}",
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),

                                  ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      buttonHeight: 52.0,
                                      buttonMinWidth: 90.0,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            GoRouter.of(context)
                                                .pushNamed("view_case", extra: {
                                              "myCase":
                                                  myCase,
                                              "caseInfo": myCase.caseInfo,
                                              "caseIvx": myCase.caseIvx
                                            });
                                          },
                                          child: const Column(
                                            children: <Widget>[
                                              Icon(Icons.open_in_full),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Text('Open'),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Column(
                                            children: <Widget>[
                                              Icon(Icons.shape_line),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Text('Share'),
                                            ],
                                          ),
                                        ),
                                      ])
                                ])
                            // ListTile(
                            //   title: Text(cases[index]['case_name']),
                            //   subtitle: Text("By: ${cases[index]["profiles"]['name']}"),
                            //   trailing: Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse(cases[index]['created_at'])) ),
                            // ),
                            );
                      },
                    );
  }
}