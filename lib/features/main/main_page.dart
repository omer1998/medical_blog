import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/notification.dart';
import 'package:medical_blog_app/core/providers/provider.dart';
import 'package:medical_blog_app/core/services/firebase_token_shared_preferences.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/algorithms/pages/algorithm_page.dart';
import 'package:medical_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:medical_blog_app/features/auth/data/models/user_model.dart';
import 'package:medical_blog_app/features/auth/domain/usecases/user_state_usecase.dart';
import 'package:medical_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medical_blog_app/features/blog/data/datasources/remote_data_source.dart';
import 'package:medical_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:medical_blog_app/features/case/data_source.dart/local_data_source.dart';
import 'package:medical_blog_app/features/case/pages/add_case_page.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/features/main/main_controller.dart';
import 'package:medical_blog_app/features/med_calc/med_calc_page.dart';
import 'package:medical_blog_app/init_dependencies.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late final FirebaseNotificationService notificationService;
  late final user;
  int _selectedIndex = 0;
  final pages = [
    BlogPage(),
    CasesPage(),
    MedCalcPage(),
    AlgorithmPage()
  ];
  late final StreamSubscription<String> onTokenRefreshStream;
  late final StreamSubscription<RemoteMessage> messageStream;
  final _pageController = PageController(initialPage: 0);
  _onPageChange(int index) {
    _pageController.jumpToPage(_selectedIndex);
  }

//    void updateRefHolder(WidgetRef ref) {
//   getIt<RefHolder>().updateRef(ref);
// }
  @override
  void initState() {
    // TODO: implement initState
    try {
      user = (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState)
          .user;
      // _initFcmToken(user);

      notificationService = FirebaseNotificationService(
          context: context,
          user: user,
          supabaseClient: getIt<SupabaseClient>());

        

       notificationService.initialize();
        onTokenRefreshStream = notificationService.firebaseMessaginInstance.onTokenRefresh.listen((token) async {
      print("token refreshed");
      await notificationService.handleFcmToken(user, refreshFcmToken: token);
    });
      FirebaseNotificationService.localNotiInit();

      // FirebaseNotificationService.flutterLocalNotificationsPlugin.
      messageStream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;

        if (notification != null) {
          print("notification from ===> ");
          print(notification.toMap());
          FirebaseNotificationService.showSimpleNotification(
              title: notification.title!,
              body: notification.body!,
              payload: jsonEncode(message.toMap()));
        }
      });

      FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService.onBackgroundHandler);
      // notificationServicce.initLocalNotification();
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    super.initState();
  }

  // _initFcmToken(UserEntity user) async {
  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   // save fcm_token in profile table in database
  //   if (fcmToken != null) {
  //     notificationService.saveFcmToken(fcmToken, user);
  //   }

  //   FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
  //     _saveFcmToken(fcmToken, user);
  //   });
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });
  //   FirebaseMessaging.onBackgroundMessage(onBackgroundHandler);
  // }

  // _saveFcmToken(String token, UserEntity user) async {
  //   try {
  //     final supabaseClient = getIt<SupabaseClient>();
  //     print("user id is ${user.id}");
  //     await supabaseClient
  //         .from("profiles")
  //         .update({"fcm_token": token}).eq("id", user.id);
  //     print("====> fcm_token inserted");
  //   } catch (e) {
  //     print("error in fcm_token insertion");
  //     print(e);
  //     showSnackBar(context, e.toString());
  //   }
  // }

  @override
  void dispose() async {
    // TODO: implement dispose
    // await onTokenRefreshStream.cancel();
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // user = (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState).user;
    return Scaffold(
      
      // appBar: AppBar(
      //   actions: [
      //     TextButton(onPressed: ()async{
      //   final res = await ref.read(casesLocalDataSourceProvider).retrieveCases();
      //     res.fold((failure){
      //         showSnackBar(context, failure.message);
      //     }, (cases){
      //       print("local cases");
      //       print(cases.length.toString());
      //     });
      //     }, child: Text("show note"))
      //   ],
      // ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              _selectedIndex = value;
              _pageController.jumpToPage(value);
            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.cases), label: "Cases"),
            NavigationDestination(
                icon: Icon(Icons.calculate), label: "MedCalc"),
                NavigationDestination(icon: Icon(Icons.dinner_dining_sharp), label: "Algs")
          ]),
    );
  }
}
