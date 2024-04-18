import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_blog_app/core/bloc_observer.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';

import 'package:medical_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:medical_blog_app/init_dependencies.dart';

import 'core/theme/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider(create: (context) => getIt<AppUserCubit>())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context)
        .add(UserStateEvent(noParams: NoParams()));
    print("----> cubit");
    print(BlocProvider.of<AppUserCubit>(context).state);
  }

  @override
  void dispose() {
    super.dispose();
    // print("----> cubit end");
    // print(BlocProvider.of<AppUserCubit>(context).state);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is UserLoggedInState;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              // print("----> cubit <-----");
              // print(BlocProvider.of<AppUserCubit>(context).state);

              return BlogPage();
            } else {
              return LoginPage();
            }
          },
        ));
  }
}
