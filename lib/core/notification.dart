import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/core/services/firebase_token_shared_preferences.dart';
import 'package:medical_blog_app/core/utils/show_snackbar.dart';
import 'package:medical_blog_app/features/case/pages/cases_page.dart';
import 'package:medical_blog_app/init_dependencies.dart';
import 'package:medical_blog_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseNotificationService {
  final SupabaseClient supabaseClient;
  final UserEntity user;
  final BuildContext context;

  final FirebaseMessaging firebaseMessaginInstance = FirebaseMessaging.instance;
  final FirebaseTokenManager localTokenManager = FirebaseTokenManager();

  FirebaseNotificationService(
      {required this.user,
      required this.supabaseClient,
      required this.context});

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

   initialize() async {
    try {
      // request permission
      firebaseMessaginInstance.requestPermission();
      print("===> initializing firebase notification service");

      // handle token involving get--check--save
      await handleFcmToken(user);
      // get token and save it
      // final token = await getToken();
      // // saving token
      // if (token != null) {
      //   await saveFcmToken(token, user);
      // }
    } catch (e) {
      print("error in initializing firebase token");
    }

// when the app is on the background
    // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  Future<String?> getToken() async {
    String? token = await firebaseMessaginInstance.getToken();
    print('Token: $token');
    return token;
  }

  saveFcmToken(String token, UserEntity user) async {
    try {
      final supabaseClient = getIt<SupabaseClient>();
      print("user id is ${user.id}");
      await supabaseClient
          .from("profiles")
          .update({"fcm_token": token}).eq("id", user.id);
      print("====> fcm_token inserted");
    } catch (e) {
      print("error in fcm_token insertion");
      print(e);
      rethrow;
    }
  }

  Future<void>  handleFcmToken(UserEntity user, {String? refreshFcmToken}) async {
    try {
      if (refreshFcmToken != null) {
        return await _saveFcmTokenWithRetry(refreshFcmToken, user);
      }
      final fcmToken = await firebaseMessaginInstance.getToken();

      if (fcmToken == null) {
        print('No FCM token available');
        return;
      }

      // Check if token has changed or needs update
      final lastSavedTokenLocally = await _getTokenLocally();
      if (lastSavedTokenLocally == null) {
        final lastSavedToken = await _getLastSavedToken(user.id);
        if (lastSavedToken != fcmToken) {
          print("previous remote saved token ${lastSavedToken}");
          print("fcm token ${fcmToken}");

          await _saveFcmTokenWithRetry(fcmToken, user);
          
          // await localTokenManager.saveToken(fcmToken);
        }
      } else {
        if (lastSavedTokenLocally.token != fcmToken) {
          print("previous local saved token ${lastSavedTokenLocally}");
          print("fcm token ${fcmToken}");
          await _saveFcmTokenWithRetry(fcmToken, user);
          // await localTokenManager.saveToken(fcmToken);
        }
      }
      print('FCM token: $fcmToken');
    } catch (e) {
      _handleTokenSaveError(e);
    }
  }

  Future<TokenInfo?> _getTokenLocally() async {
    try {
      final tokenInfo = await localTokenManager.getTokenInfo();
      return tokenInfo;
    } catch (e) {
      showSnackBar(context, 'Error retrieving token locally: $e',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red[500],
          behavior: SnackBarBehavior.floating);
    }
  }

  Future<String?> _getLastSavedToken(String userId) async {
    try {
      final response = await getIt<SupabaseClient>()
          .from('profiles')
          .select('fcm_token')
          .eq('id', userId)
          .single();

      return response['fcm_token'];
    } catch (e) {
      print('Error retrieving last saved token: $e');
      return null;
    }
  }

  Future<void> _saveFcmTokenWithRetry(String token, UserEntity user,
      {int maxRetries = 3}) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await getIt<SupabaseClient>()
            .from('profiles')
            .update({'fcm_token': token}).eq('id', user.id);

        // If successful, log and break
        print('FCM token saved successfully');

        // Optional: Store token locally to prevent unnecessary updates
        await _storeTokenLocally(token);
        return;
        break;
      } catch (e) {
        print('Token save attempt ${attempt + 1} failed: $e');

        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: attempt * 2 + 1));

        // Last attempt
        if (attempt == maxRetries - 1) {
          _handleTokenSaveError(e);
        }
      }
    }
  }

  Future<void> _storeTokenLocally(String token) async {
    try {
      await localTokenManager.saveToken(token);
    } catch (e) {
      showSnackBar(context, 'Error saving token locally: $e',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red[500],
          behavior: SnackBarBehavior.floating);
    }
  }

  void _handleTokenSaveError(dynamic error) {
    // Comprehensive error handling
    if (error is SocketException) {
      showSnackBar(
          context, 'Network error. Unable to save notification token.');
    } else if (error is TimeoutException) {
      showSnackBar(context, 'Connection timeout. Token not saved.');
    } else {
      showSnackBar(context,
          'Unexpected error saving notification token: ${error.toString()}');
    }

    // Optional: Log error for monitoring
    // FirebaseCrashlytics.instance.recordError(error, null);
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

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (notiResponse) =>
          onNotificationTap(notiResponse),
      // onDidReceiveNotificationResponse:
    );
  }

  // on tap local notification in foreground
  // on tap local notification in background
  static Future<void> onBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null) {
    print("notification is: ");
    print(notification.body);
    // GoRouter.of(context).pushNamed("cases");
  }
}
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

  static void onNotificationTap(
      NotificationResponse notificationResponse) async {
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
