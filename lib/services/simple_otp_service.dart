import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleOTPService {
  static const String _otpKey = 'stored_otp';
  static const String _emailKey = 'otp_email';
  static const String _timestampKey = 'otp_timestamp';

  static String _generateOTP() {
    final random = Random.secure();
    return (100000 + random.nextInt(900000)).toString();
  }

  static Future<bool> sendOTP(String email) async {
    try {
      final otp = _generateOTP();
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_otpKey, otp);
      await prefs.setString(_emailKey, email);
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('=== OTP GENERATED ===');
      debugPrint('Email: $email');
      debugPrint('OTP Code: $otp');
      debugPrint('Use this code in OTP screen');
      debugPrint('===================');
      
      return true;
    } catch (e) {
      debugPrint('Error generating OTP: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(String enteredOTP) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOTP = prefs.getString(_otpKey);
      final timestamp = prefs.getInt(_timestampKey);
      
      debugPrint('Verifying OTP: $enteredOTP vs $storedOTP');
      
      if (storedOTP == null || timestamp == null) {
        debugPrint('No stored OTP found');
        return false;
      }
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final otpAge = now - timestamp;
      const fiveMinutes = 5 * 60 * 1000;
      
      if (otpAge > fiveMinutes) {
        debugPrint('OTP expired');
        await clearOTP();
        return false;
      }
      
      final isValid = storedOTP == enteredOTP;
      debugPrint('OTP verification result: $isValid');
      return isValid;
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      return false;
    }
  }

  static Future<void> clearOTP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_otpKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_timestampKey);
  }

  static Future<int> getResendCooldown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_timestampKey);
      
      if (timestamp == null) return 0;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      const oneMinute = 60 * 1000;
      final elapsed = now - timestamp;
      
      if (elapsed >= oneMinute) return 0;
      
      return ((oneMinute - elapsed) / 1000).ceil();
    } catch (e) {
      return 0;
    }
  }
}