// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:medical_blog_app/core/error/exceptions.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';
import 'package:medical_blog_app/core/providers/provider.dart';

import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/utils/check_connection.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/data_source.dart/local_data_source.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/models/custom_case_model.dart';

final caseRepoProvider = Provider<CaseRepository>((ref) {
  return CaseRepositoryImpl(
      ref: ref,
      casesLocalDataSource: ref.read(casesLocalDataSourceProvider),
      connectionChecker: ref.read(connectionCheckerProvider));
});

abstract class CaseRepository {
  Future<Either<Failure, void>> addCase(
      {required String userId, required Case myCase});
  Future<List<MyCase>> retrieveCases();
  Future<List<MyCase>> retrieveCasesLocally();
  Future<Either<Failure, List<Map<String, dynamic>>>> retrieveCsesByTags(
      List<String> selectedTags);
  Future<MyCase> retrieveCaseById(String caseId);
  Future<Either<Failure, Case>> updateCase({required Case myCase});
  Future<Either<Failure, void>> addCustomCase({required CustomCaseModel myCase});
  Future<Either<Failure, void>> updateCustomCase({required CustomCaseModel myCase});
  // TODO:
  // Future<Either<Failure, void>> deleteCase({required String caseId});
}

class CaseRepositoryImpl implements CaseRepository {
  final Ref ref;
  final CasesLocalDataSource casesLocalDataSource;
  final ConnectionChecker connectionChecker;
  CaseRepositoryImpl(
      {required this.connectionChecker,
      required this.ref,
      required this.casesLocalDataSource});
  @override
  Future<Either<Failure, void>> addCase(
      {required String userId, required Case myCase}) async {
    try {
      final caseId = (await ref
          .read(supabaseClientProvider)
          .from("cases")
          .insert({
        "case_name": myCase.caseName,
        "case_author": userId,
        "tags": myCase.tags
      }).select("id"))[0]["id"];
      print("case id");
      print(caseId);

      await ref.read(supabaseClientProvider).from("cases_infos").insert({
        "case_id": caseId,
        "demographic_data": myCase.demographicData,
        "cheif_complain": myCase.cheifComplain,
        "illness_hx": myCase.illnessHx,
        "review_hx": myCase.reviewHx,
        "meds_hx": myCase.medsHx,
        "pmh": myCase.pmh,
        "psh": myCase.psh,
        "family_hx": myCase.familyHx,
        "physical_exam": myCase.physicalExam,
        "vital_signs": myCase.vitalSigns,
        "followup_notes": myCase.followUpNotes,
        "ddx": myCase.ddx,
        "management_plan": myCase.managementPlan
      });

      await ref
          .read(supabaseClientProvider)
          .from("cases_invs")
          .insert({"case_id": caseId, "inv_data": myCase.ivx});
      return right(null);
    } catch (e) {
      print(e);
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<List<MyCase>> retrieveCases() async {
    try {
      if (!await connectionChecker.isConnected) {
        final res = await casesLocalDataSource.retrieveCases();
        return res;
      }
      final cases = await ref.read(supabaseClientProvider).from("cases").select(
          "id, case_name, case_author, created_at, case_detail, tags, structured ,cases_infos(*), profiles(*), cases_invs(*)").eq("structured", true);
      final List<Map<String, dynamic>> customCases = await ref.read(supabaseClientProvider).from("cases").select("id, case_name, case_author, created_at, case_detail, tags, structured , profiles(*)").eq("structured", false);
      final List<Map<String, dynamic>> allCases = cases + customCases;
      final List<MyCase> casesModel = allCases.map((i) {
        print("ooooooooooooo");
        print((i));
        final myCase = MyCase.fromMap(i);
        print(myCase.toString());
        print(myCase.toMap());
        // print(CaseInfo.fromMap(i["cases_infos"][0] as Map<String,dynamic>) );

        return MyCase.fromMap(i);
      }).toList();
      // casesLocalDataSource.saveCases(cases);
      final casesBox = await Hive.openBox("casesBox");
      await casesBox.clear();
      casesModel.forEach((i) async {
        print("t to map");
        print(i.toMap());
        await casesBox.add(i.toMap());
      });
      await casesBox.close();
      // if (casesBox.values.length != casesModel.length){
      //   casesBox.clear();
      //   casesLocalDataSource.saveCases(casesModel);
      // }
      return casesModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> retrieveCsesByTags(
      List<String> selectedTags) async {
    try {
      List<Map<String, dynamic>> selectedCases = await ref
          .read(supabaseClientProvider)
          .from("cases")
          .select(
              "id, case_name, case_author, case_detail ,created_at, tags ,cases_infos(*), profiles(*), cases_invs(*)")
          .overlaps("tags", selectedTags);
      return right(selectedCases);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<List<MyCase>> retrieveCasesLocally() async {
    try {
      final casesBox = await Hive.openBox("casesBox");
      List<MyCase> casesModel =
          casesBox.values.map((e) => MyCase.fromMap(e)).toList();
      return casesModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MyCase> retrieveCaseById(String caseId) async {
    try {
      if (await isConnected()) {
        final caseInfo = await ref
            .read(supabaseClientProvider)
            .from("cases")
            .select(
                "id, case_name, case_author, created_at, tags ,cases_infos(*), profiles(*), cases_invs(*)")
            .eq("id", caseId)
            .single();
        return MyCase.fromMap(caseInfo);
      } else {
        throw ServerException("No Internet Connection");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, Case>> updateCase({required Case myCase}) async {
    try {
      // Update the case table
      await ref
          .read(supabaseClientProvider)
          .from("cases")
          .update({"case_name": myCase.caseName, "tags": myCase.tags}).eq(
              'id', myCase.id);

      // Update the cases_infos table
      await ref.read(supabaseClientProvider).from("cases_infos").update({
        "demographic_data": myCase.demographicData,
        "cheif_complain": myCase.cheifComplain,
        "illness_hx": myCase.illnessHx,
        "review_hx": myCase.reviewHx,
        "meds_hx": myCase.medsHx,
        "pmh": myCase.pmh,
        "psh": myCase.psh,
        "family_hx": myCase.familyHx,
        "physical_exam": myCase.physicalExam,
        "vital_signs": myCase.vitalSigns,
        "followup_notes": myCase.followUpNotes,
        "ddx": myCase.ddx,
        "management_plan": myCase.managementPlan,
      }).eq('case_id', myCase.id);

      // Update the cases_ivx table
      await ref.read(supabaseClientProvider).from("cases_invs").update({
        "inv_data": myCase.ivx,
      }).eq('case_id', myCase.id);

      // Update the local database

      return  Right(myCase);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> addCustomCase({required CustomCaseModel myCase})async {
    try {
      await ref.read(supabaseClientProvider).from("cases").insert(myCase.toMap());
      return right(null);
    } catch (e) {
      return left(Failure(message: "Error adding custom case ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateCustomCase({required CustomCaseModel myCase}) async {
   try {
     await ref.read(supabaseClientProvider).from("cases").update(myCase.toMap()).eq("id", myCase.id);
     return right(null);
   } catch (e) {
     return left(Failure(message: "Error updating custom case ${e.toString()}"));
   }
  }
  
  }

