import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medical_blog_app/core/entities/user.dart';
import 'package:medical_blog_app/init_dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print('Message notification title: ${message.notification?.title}');
  print('Message notification body: ${message.notification?.body}');
}

class FirebaseNotification {
  final _fcm = FirebaseMessaging.instance;
  final UserEntity user;
  final _androidChannal = AndroidNotificationChannel("ch1", "cases",
      description: "this channal specified for cases",
      importance: Importance.high);
  final _localNotification = FlutterLocalNotificationsPlugin();
  FirebaseNotification(this.user);

  initialize() async {
    try {
      await _fcm.requestPermission();
      final fcmToken = await _fcm.getToken();

      if (fcmToken != null) {
        await _saveFcmToken(fcmToken, user);

        _fcm.onTokenRefresh.listen((newToken) async {
          await _saveFcmToken(newToken, user);
        });

        initPushNotification();
        initLocalNotification();

        // handle background
        // handle background
        // handle background
      }
    } catch (e) {
      print(e);
    }

    // saving token
  }

  initPushNotification() async {
    // perform action when app open from tterminated state
    _fcm.getInitialMessage().then(handleMessage);

    // perform action when app open from background state
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // handle background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state

    // perform action when app open from background state
  }

  initLocalNotification() async {
    final android = AndroidInitializationSettings("@drawable/ic_laumcher");

    _localNotification.initialize(InitializationSettings(android: android),
        onDidReceiveNotificationResponse: (notificationResponse) {
      final message =
          RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
      handleMessage(message);
    });

    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform!.createNotificationChannel(_androidChannal);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotification.show(
          0,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            _androidChannal.id,
            _androidChannal.name,
            channelDescription: _androidChannal.description,
            importance: Importance.max,
            priority: Priority.high,
          )),
          payload: jsonEncode(message.toMap()));
    });
  }

  handleMessage(RemoteMessage? message) {
    print("message recieved");
  }

  Future<void> _saveFcmToken(String token, UserEntity user) async {
    // TODO: Save the token to your server or database
    try {
      final supabaseClient = getIt<SupabaseClient>();
      // print("user id is ${user.id}");
      await supabaseClient
          .from("profiles")
          .update({"fcm_token": token}).eq("id", user.id);
      // print("====> fcm_token inserted");
    } catch (e) {
      print("error in fcm_token insertion");
      print(e);
      rethrow;
    }
  }
}
