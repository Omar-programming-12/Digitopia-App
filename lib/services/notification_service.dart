import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final List<Map<String, dynamic>> _notifications = [];

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _localNotifications.initialize(initSettings);
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(
      message.notification?.title ?? 'إشعار جديد',
      message.notification?.body ?? '',
    );
  }

  static Future<void> _showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'meal_notifications',
      'إشعارات الوجبات',
      channelDescription: 'إشعارات عند إضافة وجبات جديدة',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const notificationDetails = NotificationDetails(android: androidDetails);
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  static void addNotification({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    bool isNew = true,
  }) {
    _notifications.insert(0, {
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'iconColor': iconColor,
      'time': 'الآن',
      'isNew': isNew,
      'timestamp': DateTime.now(),
    });

    _showLocalNotification(title, subtitle);
  }

  static Future<void> addMealNotification(String userName, String mealName) async {
    addNotification(
      title: 'وجبة جديدة متاحة!',
      subtitle: '$userName أضاف $mealName في منطقتك',
      icon: Icons.add_circle,
      iconColor: Colors.green,
    );

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'وجبة جديدة متاحة!',
        'subtitle': '$userName أضاف $mealName في منطقتك',
        'type': 'new_meal',
        'userName': userName,
        'mealName': mealName,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      debugPrint('خطأ في حفظ الإشعار: $e');
    }
  }

  static List<Map<String, dynamic>> getNotifications() => _notifications;
  static void clearNotifications() => _notifications.clear();
  static void markAsRead(int index) {
    if (index < _notifications.length) {
      _notifications[index]['isNew'] = false;
    }
  }
}