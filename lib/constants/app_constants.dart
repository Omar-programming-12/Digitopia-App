import 'package:flutter/material.dart';

class AppConstants {

  // Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  // Font Sizes
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 18.0;
  static const double fontXXLarge = 24.0;
  
  // animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Strings
  static const String appName = 'Digitopia';
  static const String noImagePlaceholder = 'assets/images/no_image.png';
  
  // API Endpoints
  static const String supabaseUrl = 'https://hzolhiplwpycqldeudgk.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6b2xoaXBsd3B5Y3FsZGV1ZGdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3MDM5MDYsImV4cCI6MjA3MzI3OTkwNn0.BeSadD1DqrSBsJEs6vR_ZbzJJvzAypE6Yk9pTIXnhe4';
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: AppConstants.fontXXLarge,
    fontWeight: FontWeight.bold,
    color: AppConstants.textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: AppConstants.fontXLarge,
    fontWeight: FontWeight.bold,
    color: AppConstants.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppConstants.fontLarge,
    color: AppConstants.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppConstants.fontMedium,
    color: AppConstants.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: AppConstants.fontSmall,
    color: AppConstants.textSecondary,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: AppConstants.fontMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}