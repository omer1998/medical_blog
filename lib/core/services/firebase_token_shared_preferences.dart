import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medical_blog_app/init_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseTokenManager {
  static const _tokenKey = 'fcm_token';
  static const _tokenCreatedAtKey = 'fcm_token_created_at';
  static const _tokenLastUpdatedKey = 'fcm_token_last_updated';
  static const _deviceInfoKey = 'fcm_token_device_info';

  // Singleton pattern
  static final FirebaseTokenManager _instance = FirebaseTokenManager._internal();
  factory FirebaseTokenManager() => _instance;
  FirebaseTokenManager._internal();

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs async => 
      await SharedPreferences.getInstance();

  // Generate unique device identifier
  Future<String> _getDeviceIdentifier() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    
    try {
      if (kIsWeb) {
        // Web-specific device info
        final webInfo = await deviceInfo.webBrowserInfo;
        return webInfo.userAgent ?? 'unknown_web_device';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; // Unique Android device ID
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios_device';
      }
    } catch (e) {
      print('Error getting device identifier: $e');
    }
    
    return 'unknown_device';
  }

  // Save Firebase Token with Comprehensive Metadata
  Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    final now = DateTime.now();

    try {
      // Save token
      await prefs.setString(_tokenKey, token);
      
      // Save creation timestamp
      await prefs.setInt(_tokenCreatedAtKey, now.millisecondsSinceEpoch);
      
      // Save last updated timestamp
      await prefs.setInt(_tokenLastUpdatedKey, now.millisecondsSinceEpoch);
      
      // Save device info
      final deviceId = await _getDeviceIdentifier();
      await prefs.setString(_deviceInfoKey, deviceId);

      print('Token saved successfully');
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  // Retrieve Token Information
  Future<TokenInfo?> getTokenInfo() async {
    final prefs = await _prefs;
    
    final token = prefs.getString(_tokenKey);
    final createdAt = prefs.getInt(_tokenCreatedAtKey);
    final lastUpdated = prefs.getInt(_tokenLastUpdatedKey);
    final deviceInfo = prefs.getString(_deviceInfoKey);

    if (token == null) return null;

    return TokenInfo(
      token: token,
      createdAt: createdAt != null 
        ? DateTime.fromMillisecondsSinceEpoch(createdAt) 
        : null,
      lastUpdated: lastUpdated != null 
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdated) 
        : null,
      deviceInfo: deviceInfo,
    );
  }

  // Check if token needs refresh
  Future<bool> shouldRefreshToken() async {
    final tokenInfo = await getTokenInfo();
    
    if (tokenInfo == null) return true;

    // Refresh if token is older than 30 days
    final now = DateTime.now();
    final tokenAge = now.difference(tokenInfo.createdAt ?? now);
    
    return tokenAge.inDays >= 30;
  }

  // Delete Token
  Future<void> deleteToken() async {
    final prefs = await _prefs;
    
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenCreatedAtKey);
    await prefs.remove(_tokenLastUpdatedKey);
    await prefs.remove(_deviceInfoKey);
  }
}

// Token Information Model
class TokenInfo {
  final String token;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  final String? deviceInfo;

  TokenInfo({
    required this.token,
    this.createdAt,
    this.lastUpdated,
    this.deviceInfo,
  });

  // Convenience method to check token validity
  bool get isValid => 
    token.isNotEmpty && 
    createdAt != null && 
    DateTime.now().difference(createdAt!).inDays < 30;
}

// Usage in MainPage
// class _MainPageState extends ConsumerState<MainPage> {
//   final _tokenManager = FirebaseTokenManager();

//   Future<void> _handleFirebaseToken(UserEntity user) async {
//     try {
//       // Get current FCM token
//       final fcmToken = await FirebaseMessaging.instance.getToken();
      
//       if (fcmToken == null) {
//         print('No FCM token available');
//         return;
//       }

//       // Check if token needs refresh
//       final tokenInfo = await _tokenManager.getTokenInfo();
      
//       // Conditions to update token:
//       // 1. No existing token
//       // 2. Token is older than 30 days
//       // 3. Token is different from stored token
//       if (tokenInfo == null || 
//           await _tokenManager.shouldRefreshToken() || 
//           tokenInfo.token != fcmToken) {
        
//         // Save new token locally
//         await _tokenManager.saveToken(fcmToken);
        
//         // Save to database
//         await _saveTokenToDatabase(fcmToken, user);
//       }
//     } catch (e) {
//       print('Token handling error: $e');
//       // Optional: Log error to crash reporting service
//     }
//   }

//   Future<void> _saveTokenToDatabase(String token, UserEntity user) async {
//     try {
//       await getIt<SupabaseClient>()
//           .from('profiles')
//           .update({'fcm_token': token})
//           .eq('id', user.id);
      
//       print('Token saved to database successfully');
//     } catch (e) {
//       print('Database token save error: $e');
//       // Optionally retry or handle error
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Listen for token refreshes
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       final user = (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState).user;
//       _handleFirebaseToken(user);
//     });

//     // Initial token setup
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final user = (BlocProvider.of<AppUserCubit>(context).state as UserLoggedInState).user;
//       _handleFirebaseToken(user);
//     });
//   }
// }