import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SecureStorage {
  static const String _userTokenKey = 'user_token';
  static const String _userIdKey = 'user_id';
  static const String _lastLoginKey = 'last_login';

  static Future<void> saveUserToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userTokenKey, token);
    } catch (e) {
      debugPrint('Error saving token: $e');
    }
  }

  static Future<String?> getUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTokenKey);
    } catch (e) {
      debugPrint('Error getting token: $e');
      return null;
    }
  }

  static Future<void> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userId);
    } catch (e) {
      debugPrint('Error saving user ID: $e');
    }
  }

  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      debugPrint('Error getting user ID: $e');
      return null;
    }
  }

  static Future<void> saveLastLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Error saving last login: $e');
    }
  }

  static Future<DateTime?> getLastLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastLoginKey);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      debugPrint('Error getting last login: $e');
      return null;
    }
  }

  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userTokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_lastLoginKey);
    } catch (e) {
      debugPrint('Error clearing storage: $e');
    }
  }
}