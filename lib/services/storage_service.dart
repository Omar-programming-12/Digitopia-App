import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Int operations
  static Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  // Bool operations
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // List operations
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  // JSON operations
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await setString(key, jsonString);
  }

  static Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Remove operations
  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  // Check if key exists
  static bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  // App specific keys
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String cacheKey = 'cache_data';
  static const String lastLocationKey = 'last_location';
  static const String themeKey = 'theme_mode';

  // User data operations
  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    return await setJson(userDataKey, userData);
  }

  static Map<String, dynamic>? getUserData() {
    return getJson(userDataKey);
  }

  // Settings operations
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    return await setJson(settingsKey, settings);
  }

  static Map<String, dynamic>? getSettings() {
    return getJson(settingsKey);
  }

  // Location operations
  static Future<bool> saveLastLocation(String location) async {
    return await setString(lastLocationKey, location);
  }

  static String? getLastLocation() {
    return getString(lastLocationKey);
  }
}