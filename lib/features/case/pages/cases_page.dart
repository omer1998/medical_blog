// we will use riverpod as state management solution
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/add_case_page.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_view.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class CasesPage extends ConsumerWidget {
  CasesPage({super.key});

  // final cases = .... ? from the supabase
  @override
  Widget build(BuildContext context, WidgetRef ref) {
      // final GlobalKey<ExpansionTileCardState> expansionCardKey = GlobalKey();

    return Scaffold(
        appBar: AppBar(
          title: Text("Cases"),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // GoRouter.of(context).goNamed('add_case');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCasePage()));
            },
            child: Icon(Icons.add)),
// Navigator.push(context, MaterialPageRoute(builder: (context) => CaseCreatePage()));
// Navigator.pushNamed(context, '/case/create');
// Navigator.push(context, MaterialPageRoute(builder: (context) => CaseCreatePage()));},

        body: ref.watch(getCasesProvider).when(
            data: (cases) {
              return ListView.builder(
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  // print("item count is --> ${cases.length}");
                  // print(cases[index]);
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                          title: Text(
                            (cases[index]['case_name'] as String).capitalize(),
                            style: TextStyle(fontSize: 18),
                          ),
                          backgroundColor: Colors.purple,
                          collapsedBackgroundColor:
                              Color.fromARGB(255, 110, 7, 120),
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
                            Text(DateFormat('dd-MMM-yyyy').format(DateTime.parse(cases[index]['created_at'] ))),
                            // Text(cases[index]['case_date'] as String),
                            // Text(cases[index]['case_date'] as String),
                            // Text(cases[index]['case_date'] as String),
                            // Text(cases[index]['case_date'] as String),
                            // Text(cases[index]['case_date'] as String),
                            // Text(cases[index]['case_date'] as String),
                            // Text(cases[index]['case_date'] as String),
                            ButtonBar(
                                alignment: MainAxisAlignment.spaceAround,
                                buttonHeight: 52.0,
                                buttonMinWidth: 90.0,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).pushNamed("view_case", extra: {
                                        "myCase": MyCase.fromMap(cases[index]),
                                        "caseInfo": CaseInfo.fromMap(cases[index]['cases_infos'][0]),
                                        "caseIvx": CaseIvx.fromMap(cases[index]['cases_invs'][0])
                                      } );
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
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text("Error: $error"))));
  }
}
