import 'dart:convert';
import 'dart:io';
import 'package:digitopia_app/models/meal_model.dart';
import 'package:digitopia_app/services/supabase_image_service.dart';
import 'package:digitopia_app/utils/cache_manager.dart';
import 'package:digitopia_app/utils/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealService {
  static const String baseUrl = "http://192.168.1.11:8000";

  static Stream<List<Meal>> mealsStream() async* {
    while (true) {
      try {
        yield await getMeals();
      } catch (e) {
        debugPrint('Error in meals stream: $e');
        yield [];
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  static Future<String?> uploadImage(File? file) async {
    if (file == null) return null;
    
    try {
      return await SupabaseImageService.uploadImage(file);
    } catch (e) {
      debugPrint('خطأ في رفع الصورة: $e');
      return null;
    }
  }

  static Future<bool> addMeal({
    required String name,
    required int quantity,
    required String location,
    String? imageUrl,
    String? userName,
    String? description,
    double? latitude,
    double? longitude,
    String privacy = 'public',
  }) async {
    try {
      final response = await NetworkHelper.postWithRetry(
        "$baseUrl/api/meals/add/",
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "location_text": location,
          "latitude": latitude ?? 0.0,
          "longitude": longitude ?? 0.0,
          "image_url": imageUrl,
          "quantity": quantity,
          "privacy": privacy,
          "userName": userName ?? 'مستخدم',
        }),
      );

      if (response != null && response.statusCode == 201) {
        debugPrint("Meal added successfully - notification sent automatically");
        await CacheManager.clearCache();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding meal: $e');
      return false;
    }
  }

  static Future<List<Meal>> getMeals() async {
    try {
      final cachedMeals = await CacheManager.getCachedMeals();
      if (cachedMeals != null) {
        return cachedMeals.map((json) => Meal.fromJson(json)).toList();
      }

      final response = await NetworkHelper.getWithRetry(
        "$baseUrl/api/meals/",
        headers: {"Content-Type": "application/json"},
      );

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        await CacheManager.cacheMeals(data.cast<Map<String, dynamic>>());
        return data.map((json) => Meal.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting meals: $e');
      final cachedMeals = await CacheManager.getCachedMeals();
      if (cachedMeals != null) {
        return cachedMeals.map((json) => Meal.fromJson(json)).toList();
      }
      return [];
    }
  }

  static Future<bool> setAvailability(String mealId, bool available) async {
    try {
      final url = Uri.parse("$baseUrl/api/meals/$mealId/availability/");
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"available": available}),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating meal availability: $e');
      return false;
    }
  }
  
  static Stream<List<Meal>> getMealsByLocation(String location) async* {
    while (true) {
      try {
        final meals = await getMeals();
        yield meals.where((meal) => 
          meal.location.toLowerCase().contains(location.toLowerCase()) && meal.available
        ).toList();
      } catch (e) {
        debugPrint('Error getting meals by location: $e');
        yield [];
      }
      await Future.delayed(const Duration(seconds: 15));
    }
  }
  
  static Future<bool> deleteMeal(String mealId) async {
    try {
      final url = Uri.parse("$baseUrl/api/meals/$mealId/delete/");
      final response = await http.delete(url);

      return response.statusCode == 204;
    } catch (e) {
      debugPrint('Error deleting meal: $e');
      return false;
    }
  }
}
