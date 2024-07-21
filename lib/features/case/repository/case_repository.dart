// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/providers/provider.dart';

import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';

final caseRepoProvider = Provider<CaseRepository>((ref) {
  return CaseRepositoryImpl(ref: ref);
});

abstract class CaseRepository {
  Future<Either<Failure, void>> addCase(
      {required String userId, required Case myCase});
  Future<List<Map<String, dynamic>>> retrieveCases();
}

class CaseRepositoryImpl implements CaseRepository {
  final Ref ref;
  CaseRepositoryImpl({
    required this.ref,
  });
  @override
  Future<Either<Failure, void>> addCase(
      {required String userId, required Case myCase}) async {
    try {
      final caseId =
          (await ref.read(supabaseClientProvider).from("cases").insert({
        "case_name": myCase.caseName,
        "case_author": userId,
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
  Future<List<Map<String, dynamic>>> retrieveCases() async {
    try {
      final cases = await ref
          .read(supabaseClientProvider)
          .from("cases")
          .select("id, case_name, case_author, created_at, cases_infos(*), profiles(*), cases_invs(*)");
      
      print("cases from supabase");
      print(cases[0]["cases_invs"]);
      // final info = await ref.read(supabaseClientProvider).from("cases_infos").select("id, cheif_complain");
      // print(info);
      return cases;
    } catch (e) {
      rethrow;
    }
  }
}
