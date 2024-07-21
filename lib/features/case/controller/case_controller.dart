import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/repository/case_repository.dart';

final getCasesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  return ref.read(caseControllerProvider).retrieveCases();
});
final caseControllerProvider = Provider<CaseController>((ref) {
  return CaseController(ref: ref);
});

class CaseController {
  final Ref ref;

  CaseController({required this.ref});

 Future<List<Map<String, dynamic>>> retrieveCases() async {
try {
      final cases = await ref.read(caseRepoProvider).retrieveCases();
      return cases;
 
} catch (e) {
throw e;}  }

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
