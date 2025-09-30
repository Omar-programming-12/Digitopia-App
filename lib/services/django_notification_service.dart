import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DjangoNotificationService {
  static const String baseUrl = 'http://localhost:8000/api'; // Django backend محلي
  
  // إرسال إشعار عبر Django عند إضافة وجبة
  static Future<bool> sendMealNotification({
    required String userName,
    required String mealName,
    required String location,
    String? imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/meal-added/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_name': userName,
          'meal_name': mealName,
          'location': location,
          'image_url': imageUrl,
          'notification_type': 'new_meal',
          'title': 'وجبة جديدة متاحة!',
          'body': '$userName أضاف $mealName في $location',
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('تم إرسال الإشعار لـ ${responseData['sent_to'] ?? 0} مستخدم');
        return true;
      } else {
        debugPrint('فشل إرسال الإشعار: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('خطأ في إرسال الإشعار: $e');
      return false;
    }
  }

  // تسجيل FCM token في Django
  static Future<bool> registerFCMToken(String token, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/register-token/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcm_token': token,
          'user_id': userId,
          'platform': 'android', // أو ios
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('خطأ في تسجيل FCM Token: $e');
      return false;
    }
  }

  // إرسال إشعار مخصص
  static Future<bool> sendCustomNotification({
    required String title,
    required String body,
    required String notificationType,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/send/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'notification_type': notificationType,
          'data': data,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('خطأ في إرسال الإشعار المخصص: $e');
      return false;
    }
  }
}