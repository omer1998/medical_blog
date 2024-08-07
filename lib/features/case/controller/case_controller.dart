import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/case/repository/case_repository.dart';

final getCasesProvider = FutureProvider.autoDispose<List<MyCase>>((ref) async {
  return ref.read(caseControllerProvider).retrieveCases();
});
final caseControllerProvider = Provider<CaseController>((ref) {
  return CaseController(ref: ref);
});

class CaseController {
  final Ref ref;

  CaseController({required this.ref});

  retriveCasesByTags(BuildContext context) async {
    final selectedTags = ref.read(selectedTagsProvider);
    if (selectedTags.isEmpty) {
      showSnackBar(context, "Please select at least one tag");
      return;
    }
    final res =
        await ref.read(caseRepoProvider).retrieveCsesByTags(selectedTags);
    res.fold((failure) {
      showSnackBar(context, failure.message);
      print("cases tags error ${failure.message}");
    }, (cases) {
      showSnackBar(context, cases.length.toString());
    });
  }

  Future<List<MyCase>> retrieveCases() async {
    try {
      final cases = await ref.read(caseRepoProvider).retrieveCases();
      print("Cases from supabase");
      print(cases);
      return cases;
    } catch (e) {
      throw e;
    }
  }

  Future<Either<Failure, List<MyCase>>> retrieveCasesLocally() async {
    try {
      final allCasesLocally =
          await ref.read(caseRepoProvider).retrieveCasesLocally();
      return Right(allCasesLocally);
    } catch (e) {
      // showSnackBar(context, "Error retrieving cases locally");
      return Left(Failure(message: "Error retrieving cases locally"));
    }
  }

  addCase(BuildContext context, Case myCase) async {
    final id =
        (context.read<AppUserCubit>().state as UserLoggedInState).user.id;
    print("user id ");
    print(id);
    final res =
        await ref.read(caseRepoProvider).addCase(userId: id, myCase: myCase);
    res.fold((f) {
      print("error");
      print(f.message);
      showSnackBar(context, f.message);
    }, (r) {
      print("map");
      showSnackBar(context, "Case added Successfuly");
    });
  }
}
