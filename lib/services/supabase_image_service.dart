import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseImageService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String bucketName = 'meals';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = '${const Uuid().v4()}.jpg';
      
      await _supabase.storage
          .from(bucketName)
          .upload(fileName, imageFile);

      final imageUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print('خطأ في رفع الصورة: $e');
      return null;
    }
  }

  static Future<bool> deleteImage(String imageUrl) async {
    try {
      final fileName = imageUrl.split('/').last;
      
      await _supabase.storage
          .from(bucketName)
          .remove([fileName]);
      
      return true;
    } catch (e) {
      print('خطأ في حذف الصورة: $e');
      return false;
    }
  }
}