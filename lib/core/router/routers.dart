import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:medical_blog_app/features/case/models/case_info_model.dart';
import 'package:medical_blog_app/features/case/models/case_ivx_model.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/features/case/pages/add_case_page.dart';
import 'package:medical_blog_app/features/case/pages/case_view_page.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/main/main_page.dart';
import 'package:medical_blog_app/features/profile/page/edit_profile_page.dart';
import 'package:medical_blog_app/features/profile/page/profile_page.dart';

final router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(
        path: '/',
        name: "main",
        builder: (context, state) => MainPage(),
        routes: [
          GoRoute(path: "profile", name: "profile", builder:(context, state) {
            final userModel = state.extra as UserModel;
            return ProfilePage(user: userModel);
          },routes: [
            GoRoute(path: "edit_profile", name: "edit_profile", builder:(context, state) {
              final userModel = state.extra as UserModel;
              return EditProfilePage(user: userModel);
            })
          ]),
          GoRoute(
              path: "case",
              name: "case",
              builder: (context, state) => CasesPage(),
              routes: [
                GoRoute(
                    path: "view_case",
                    name: "view_case",
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      final myCase = extra["myCase"] as MyCase;
                      final caseInfo = extra['caseInfo'] as CaseInfo;
                      final caseIvx = extra["caseIvx"] as CaseIvx;
                      return CaseViewPage(
                        myCase: myCase,
                        caseInfo: caseInfo,
                        caseIvx: caseIvx,
                      );
                    }),
                GoRoute(
                  path: "add_case",
                  name: "add_case",
                  builder: (context, state) => AddCasePage(),
                ),
              ])
        ]),
    GoRoute(
      path: "/cases",
      name: "cases",
      builder: (context, state) => CasesPage(),
    ),
    GoRoute(
      path: "/login",
      name: "login",
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) {
        AppUserState state =
            BlocProvider.of<AppUserCubit>(context, listen: false).state;
        print("yyyy");
        print(state);
        if (state is UserLoggedInState) {
          return "/";
        } else {
          return '/login';
        }
      },
    ),
    GoRoute(
      path: "/register",
      name: "register",
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: "/logout",
      name: "logout",
      builder: (context, state) => const MainPage(),
    ),
  ],
);
