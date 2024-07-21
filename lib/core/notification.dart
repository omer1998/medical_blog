import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/init_dependencies.dart';
import 'package:medical_blog_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseNotificationService {
  final SupabaseClient supabaseClient;
  final UserEntity user;
  final BuildContext context;
  
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  FirebaseNotificationService({required this.user, required this.supabaseClient, required this.context});


 static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initialize() async {
    try {
      final firebaseMessaginInstance =  FirebaseMessaging.instance;
      firebaseMessaginInstance.requestPermission();

    // get token and save it 
    final token = await getToken();
    // saving token
    if (token != null) {
      await _saveFcmToken(token, user);
    }

firebaseMessaginInstance.onTokenRefresh.listen((token) async {
      print("token refreshed");
      await _saveFcmToken(token, user);
    });
    } catch (e) {
      print("Initialization error");
      rethrow;
    }


// when the app is on the background
    // FirebaseMessaging.onBackgroundMessage(backgroundHandler); 

  }

  Future<String?> getToken() async {
    String? token = await fcm.getToken();
    print('Token: $token');
    return token;
  }
  
  _saveFcmToken(String token, UserEntity user) async {
  try {
     
          final supabaseClient = getIt<SupabaseClient>();
          print("user id is ${user.id}");
          await supabaseClient.from("profiles").update({"fcm_token":token}).eq("id", user.id);
          print("====> fcm_token inserted");
      
  } catch (e) {
    print("error in fcm_token insertion");
    print(e);
    rethrow;
  }
 
}


    static Future localNotiInit() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
            
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveBackgroundNotificationResponse: (notiResponse)=> onNotificationTap(notiResponse),
    // onDidReceiveNotificationResponse: 
       );
  }

  // on tap local notification in foreground
   

 
  // show a simple notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static void onNotificationTap(NotificationResponse notificationResponse)async {
    // navigate to cases page
    print("notification payload");
    print(notificationResponse.payload);
    

  }

   
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print("title: ${message.notification!.title}");
  print("body: ${message.notification!.body}");
  print("data: ${message.data}");
  // TODO: handle the message

}
