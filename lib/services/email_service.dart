import 'dart:math';
import 'package:digitopia_app/utils/otp_generator.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailService {
  static const String _otpKey = 'stored_otp';
  static const String _emailKey = 'otp_email';
  static const String _timestampKey = 'otp_timestamp';

  static String _generateOTP() {
    return OTPGenerator.generate6Digits();
  }

  static Future<bool> sendOTP(String email) async {
    try {
      final otp = _generateOTP();
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_otpKey, otp);
      await prefs.setString(_emailKey, email);
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
      
      try {
        await _sendEmailOTP(email, otp);
        debugPrint('Email sent successfully to: $email');
        debugPrint('OTP Code: $otp');
        return true;
      } catch (emailError) {
        debugPrint('Email sending failed: $emailError');
        debugPrint('But OTP is stored locally: $otp');
        debugPrint('Use this code for testing: $otp');
        return true; // Still return true since OTP is stored
      }
    } catch (e) {
      debugPrint('Failed to generate OTP: $e');
      return false;
    }
  }

  static Future<void> _sendEmailOTP(String email, String otp) async {
    try {
      final smtpServer = gmail('omar.badawi.rm2020@gmail.com', 'brfodkhknvmrsbov');
      
      final message = Message()
        ..from = const Address('omar.badawi.rm2020@gmail.com', 'Digitopia')
        ..recipients.add(email)
        ..subject = 'Digitopia - Verification Code'
        ..text = 'Your verification code is: $otp'
        ..html = '''
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #6366F1, #8B5CF6); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
              <h1 style="color: white; margin: 0;">Digitopia</h1>
              <p style="color: rgba(255,255,255,0.8); margin: 10px 0 0 0;">Share your meals with neighbors</p>
            </div>
            <div style="background: white; padding: 30px; border-radius: 0 0 10px 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
              <h2 style="color: #333; text-align: center;">Your Verification Code</h2>
              <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;">
                <h1 style="color: #6366F1; font-size: 32px; letter-spacing: 8px; margin: 0;">$otp</h1>
              </div>
              <p style="color: #666; text-align: center;">This code is valid for 5 minutes only</p>
              <p style="color: #666; text-align: center; font-size: 14px;">If you didn't request this code, please ignore this email</p>
            </div>
          </div>
        ''';
      
      await send(message, smtpServer);
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> verifyOTP(String enteredOTP) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOTP = prefs.getString(_otpKey);
      final timestamp = prefs.getInt(_timestampKey);
      
      if (storedOTP == null || timestamp == null) {
        return false;
      }
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final otpAge = now - timestamp;
      const fiveMinutes = 5 * 60 * 1000;
      
      if (otpAge > fiveMinutes) {
        await clearOTP();
        return false;
      }
      
      return storedOTP == enteredOTP;
    } catch (e) {
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