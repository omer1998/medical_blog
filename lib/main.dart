import 'dart:convert';
import 'dart:ffi';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_blog_app/core/bloc_observer.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/notification.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/router/routers.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';

import 'package:medical_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:medical_blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/bloc/blog_bloc.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/main/main_controller.dart';
import 'package:medical_blog_app/features/main/main_page.dart';
import 'package:medical_blog_app/features/med_calc/med_calc_page.dart';
import 'package:medical_blog_app/firebase_options.dart';
import 'package:medical_blog_app/init_dependencies.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  //  FirebaseNotificationService.flutterLocalNotificationsPlugin.
  

  Bloc.observer = MyBlocObserver();

  await Hive.initFlutter();
  final blogsBox = await Hive.openBox("blogs");
  
  await initDependencies(blogsBox);
  String storageLocation = (await getApplicationDocumentsDirectory()).path;
  await FastCachedImageConfig.init(
      subDir: storageLocation, clearCacheAfter: const Duration(days: 15));
  // FlutterQuillExtensions.useSuperClipboardPlugin();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider(create: (context) => getIt<AppUserCubit>()),
        BlocProvider(create: (context) => getIt<BlogBloc>())
      ],
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // final PushNotificationService _notificationService =
  //     PushNotificationService();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context)
        .add(UserStateEvent(noParams: NoParams()));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // _notificationService.initialize();
    // print("token is: ");
    // print(_notificationService.getToken());

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}


// BlocBuilder<AppUserCubit,AppUserState>(builder: (context, state) {
//           if (state is UserLoggedInState){
//             return MainPage();
//           }else {
//             return LoginPage();
//           }

          