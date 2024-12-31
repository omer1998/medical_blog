// we will use riverpod as state management solution
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/controller/case_controller.dart';
import 'package:medical_blog_app/features/case/data_source.dart/local_data_source.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/add_case_page.dart';
import 'package:medical_blog_app/features/case/pages/widgets/case_view.dart';
import 'package:medical_blog_app/features/case/pages/widgets/cases_list.dart';
import 'package:medical_blog_app/features/case/pages/widgets/professional_case_card.dart';
import 'package:medical_blog_app/features/case/pages/widgets/tags_chips_filter.dart';
import 'package:medical_blog_app/features/case/repository/case_repository.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

final selectedTagsProvider = StateProvider<List<String>>((ref) {
  return [];
});

// First, create a filter provider
final selectedFilterProvider = StateProvider<String?>((ref) => null);

class CasesPage extends ConsumerStatefulWidget {
  final List<MyCase>? cases;
  const CasesPage({this.cases, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CasesPageState();
}

class _CasesPageState extends ConsumerState<CasesPage> {
  List<String> tags = [
    "Respiratory",
    "Cardiology",
    "MI",
    "COPD",
    "Asthma",
    "Pulmonary Embolism"
  ];
  List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    // final GlobalKey<ExpansionTileCardState> expansionCardKey = GlobalKey();
    final userId = (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState ).user.id;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0, // the point of this property is to remove the shadow
          backgroundColor: AppPallete.backgroundColor,
          title: Text("Cases"),
          actions: [
            
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                child: Divider(
                                  thickness: 3,
                                  color: Colors.white,
                                ),
                                width: 30,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Filter By Tags",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TagsChips(tags: tags),
                              SizedBox(
                                height: 15,
                              ),
                              FilledButton(
                                  onPressed: () async {
                                    if (ref.read(selectedTagsProvider).isEmpty) {
                                      ref.read(selectedCasesProvider.notifier).update((state) => null);
                                      final res = await ref.read(caseControllerProvider).retrieveCasesLocally();
                                      res.fold((f){
                                        showSnackBar(context, f.message);
                                      }, (cases){
                                        showSnackBar(context, "fetching cases from local DB");
                                        ref.read(selectedCasesProvider.notifier).update((state) => cases);
                          
                                      });
                                      Navigator.of(context).pop();
                          
                                      return;
                                      // ref.read(selectedCasesProvider.notifier).update((state)=> null);
                                      // Navigator.of(context).pop();
                                      // return;
                                    }
                                    final res = await ref
                                        .read(casesLocalDataSourceProvider)
                                        .retrieveCasesByTags(
                                            ref.read(selectedTagsProvider));
                                    res.fold((f) {
                                      showSnackBar(context, f.message);
                                    }, (cases) {
                                      ref
                                          .read(selectedCasesProvider.notifier)
                                          .update((state) => cases);
                                      // Navigator.pop(context);
                                      showSnackBar(
                                          context, cases.length.toString());
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Text("Filter"))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon:  Icon(ref.read(selectedTagsProvider).isNotEmpty
                    ? Icons.filter_list
                    : Icons.filter_list_off),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              //ref.read(selectedTagsProvider.notifier).state = [];
              GoRouter.of(context).pushNamed('add_case', extra:  userId );
              // try {
              //   print(await ref.read(caseRepoProvider).retrieveCases());
              // } catch (e) {
              //   print("errr retrieving cases");

              //   print(e);
              // }
              // ref.read(casesLocalDataSourceProvider).saveCase(MyCase(
              //         id: "ourururuhs",
              //         case_name: "Middle age male with severe headache",
              //         case_author: "Omer Faris",
              //         created_at: "22 jul 2024",
              //         tags: [
              //           "Respiratory",
              //           "Cardiology",
              //           "MI",
              //           "COPD",
              //         ]));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => AddCasePage()));
            },
            child: Icon(Icons.add)),
// Navigator.push(context, MaterialPageRoute(builder: (context) => CaseCreatePage()));
// Navigator.pushNamed(context, '/case/create');
// Navigator.push(context, MaterialPageRoute(builder: (context) => CaseCreatePage()));

        body: Container(
          decoration: BoxDecoration(
            // color: AppPallete.gradient1.withOpacity(0.2),
          //  gradient: LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [
          //       AppPallete.gradient1.withOpacity(0.7),
          //       AppPallete.backgroundColor
          //     ],
          //   ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Filter by",
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //   ),
              // ),
              buildFilterChips(ref),
              Expanded(
                child: ref.watch(filteredCasesProvider).when(
                  data: (cases) {
                    if(cases.isEmpty){
                      return Center(child: Text("No cases found"),);
                    }
                    return ListView.builder(
                    itemCount: cases.length,
                    itemBuilder: (context, index) {
                      // print("item count is --> ${cases.length}");
                      // print(cases[index]["tags"]);
                      final myCase = cases[index];
                      // return ProfessionalCaseCard(caseModel: myCase,);
                      return buildCaseItem(myCase, context);
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
                                  "by ${myCase.name!.capitalize()}"),
                              backgroundColor:
                                  const Color.fromARGB(255, 58, 4, 27),
                              collapsedBackgroundColor:
                                  const Color.fromARGB(255, 76, 3, 96),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10.0)),
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10.0)),
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
                                              ? myCase.tags
                                                  !.map((tag) {
                                                  // print("case tags");
                                                  // print(cases[index]["tags"]);
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                    child: Chip(
                                                        backgroundColor:
                                                            Colors.grey,
                                                        side: BorderSide
                                                            .none,
                                                        clipBehavior: Clip
                                                            .antiAlias,
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
                                    alignment:
                                        MainAxisAlignment.spaceAround,
                                    buttonHeight: 52.0,
                                    buttonMinWidth: 90.0,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          GoRouter.of(context).pushNamed(
                                              "view_case",
                                              extra: {
                                                "myCase": myCase,
                                                "caseInfo": myCase.caseInfo,
                                                "caseIvx": myCase.caseIvx
                                              });
                                        },
                                        child: const Column(
                                          children: <Widget>[
                                            Icon(Icons.open_in_full),
                                            Padding(
                                              padding:
                                                  EdgeInsets.symmetric(
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
                                              padding:
                                                  EdgeInsets.symmetric(
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
                  error: (error, stackTrace) => Center(
                        child: Text("This is error: ${error.toString()}"),
                      )),
              )
            ],
          ),
        ));
  }
}

// Add this widget above your cases list
Widget buildFilterChips(WidgetRef ref) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        FilterChip(
          label: const Text('All'),
          selected: ref.watch(selectedFilterProvider) == null,
          onSelected: (_) => ref.read(selectedFilterProvider.notifier).state = null,
          backgroundColor: AppPallete.backgroundColor,
          selectedColor: AppPallete.gradient1.withOpacity(0.2),
          labelStyle: TextStyle(
            color: ref.watch(selectedFilterProvider) == null 
                ? AppPallete.gradient1 
                : AppPallete.whiteColor.withOpacity(0.7),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: ref.watch(selectedFilterProvider) == null 
                  ? AppPallete.gradient1 
                  : AppPallete.borderColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ...ref.read(getCasesTagsProvider).map((topic) {
          final isSelected = ref.watch(selectedFilterProvider) == topic;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                ref.read(selectedFilterProvider.notifier).state = 
                    selected ? topic : null;
              },
              backgroundColor: AppPallete.backgroundColor,
              selectedColor: AppPallete.gradient1.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected 
                    ? AppPallete.gradient1 
                    : AppPallete.whiteColor.withOpacity(0.7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected 
                      ? AppPallete.gradient1 
                      : AppPallete.borderColor,
                ),
              ),
            ),
          );
        }),
      ],
    ),
  );
}

// Modify your getCasesProvider to include filtering
final filteredCasesProvider = Provider<AsyncValue<List<MyCase>>>((ref) {
  final cases = ref.watch(getCasesProvider);
  final filter = ref.watch(selectedFilterProvider);
  
  return cases.when(
    data: (casesList) {
      if (filter == null) return AsyncValue.data(casesList);
      return AsyncValue.data(
        casesList.where((c) => c.tags!.contains(filter) ).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});
