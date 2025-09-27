import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  
  static const String baseUrl = 'https://your-api-url.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String defaultImagePath = 'assets/images/no_image.png';
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

class AppStrings {
  static const String appName = 'Digitopia';
  static const String home = 'الرئيسية';
  static const String map = 'الخريطة';
  static const String addMeal = 'إضافة وجبة';
  static const String chats = 'المحادثات';
  static const String profile = 'الملف الشخصي';
  static const String loading = 'جاري التحميل...';
  static const String error = 'حدث خطأ';
  static const String success = 'تم بنجاح';
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
}