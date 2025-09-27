import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailVerificationService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/auth';

  static Future<Map<String, dynamic>> sendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'فشل في إرسال رمز التحقق'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'تأكد من اتصالك بالإنترنت'
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOTP(String email, String otpCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp_code': otpCode,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'رمز التحقق غير صحيح'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'تأكد من اتصالك بالإنترنت'
      };
    }
  }
}