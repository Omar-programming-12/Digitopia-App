import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitopia_app/models/meal_model.dart';
import 'package:digitopia_app/services/supabase_image_service.dart';
import 'package:flutter/material.dart';

class MealService {
  static final CollectionReference _col = FirebaseFirestore.instance.collection('meals');

  // Stream for real-time updates
  static Stream<List<Meal>> mealsStream() {
    return _col.orderBy('timestamp', descending: true).snapshots().map(
      (snap) => snap.docs.map((doc) => Meal.fromDoc(doc)).toList(),
    );
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

  // add meal document
  static Future<bool> addMeal({
    required String name,
    required int quantity,
    required String location,
    String? imageUrl,
    String? userName,
    String? description,
  }) async {
    try {
      await _col.add({
        'name': name,
        'quantity': quantity,
        'location': location,
        'imageUrl': imageUrl,
        'userName': userName ?? 'مستخدم',
        'description': description ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'available': true,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error adding meal: $e');
      return false;
    }
  }

  // optional: mark meal reserved / not available
  static Future<bool> setAvailability(String docId, bool available, Timestamp? expired) async {
    try {
      final updateData = {
        'available': available,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      if (expired != null) {
        updateData['expired'] = expired;
      }
      
      await _col.doc(docId).update(updateData);
      return true;
    } catch (e) {
      debugPrint('Error updating meal availability: $e');
      return false;
    }
  }
  
  // Get meals by location
  static Stream<List<Meal>> getMealsByLocation(String location) {
    return _col
        .where('location', isEqualTo: location)
        .where('available', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Meal.fromDoc(doc)).toList());
  }
  
  // Delete meal
  static Future<bool> deleteMeal(String docId) async {
    try {
      await _col.doc(docId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting meal: $e');
      return false;
    }
  }
}
