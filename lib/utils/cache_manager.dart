import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _mealsKey = 'cached_meals';
  static const String _lastUpdateKey = 'last_meals_update';
  static const Duration _cacheExpiry = Duration(minutes: 10);

  static Future<void> cacheMeals(List<Map<String, dynamic>> meals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mealsKey, jsonEncode(meals));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<Map<String, dynamic>>?> getCachedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    
    if (lastUpdate == null) return null;
    
    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    if (DateTime.now().difference(lastUpdateTime) > _cacheExpiry) {
      return null;
    }
    
    final cachedData = prefs.getString(_mealsKey);
    if (cachedData == null) return null;
    
    try {
      final List<dynamic> decoded = jsonDecode(cachedData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mealsKey);
    await prefs.remove(_lastUpdateKey);
  }

  static Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    
    if (lastUpdate == null) return false;
    
    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    return DateTime.now().difference(lastUpdateTime) <= _cacheExpiry;
  }
}