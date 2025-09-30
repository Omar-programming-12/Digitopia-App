import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static const String baseUrl = "http://192.168.1.11:8000";

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  static Future<void> init() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    String? token = await _fcm.getToken();
    if (token != null) {
      print('FCM Token: $token');
      await _sendTokenToBackend(token);
    }

    _fcm.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      _sendTokenToBackend(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in foreground');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification: ${message.notification!.title} - ${message.notification!.body}');
        _showForegroundNotification(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User opened the app from notification');
      if (message.data['type'] == 'new_meal') {
        String? mealId = message.data['meal_id'];
        print('Opening meal with ID: $mealId');
      }
    });

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state');
      if (initialMessage.data['type'] == 'new_meal') {
        String? mealId = initialMessage.data['meal_id'];
        print('Opening meal with ID: $mealId');
      }
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message: ${message.messageId}');
  }

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final url = Uri.parse("$baseUrl/api/register-device/");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fcm_token": token}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Token registration timeout'),
      );

      if (response.statusCode == 201) {
        print("Token saved successfully on backend");
      } else {
        print("Failed to save token: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error sending token: $e");
    }
  }

  static void _showForegroundNotification(RemoteMessage message) {
    print('Showing foreground notification: ${message.notification?.title}');
  }
}
