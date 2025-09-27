import 'dart:async';
import 'package:digitopia_app/constants/app_constants.dart';
import 'package:digitopia_app/presentation/pages/main_navigation.dart';
import 'package:digitopia_app/services/auth_service.dart';
import 'package:digitopia_app/services/email_verification_service.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final String password;

  const OTPScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _resendCooldown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer() {
    if (_resendCooldown > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _resendCooldown--;
          if (_resendCooldown <= 0) {
            timer.cancel();
          }
        });
      });
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _showMessage('يرجى إدخال الرمز كاملاً');
      return;
    }

    setState(() => _isLoading = true);

    // Try Django first, then fallback to local
    Map<String, dynamic> result;
    try {
      result = await EmailVerificationService.verifyOTP(widget.email, otp);
    } catch (e) {
      // Fallback to local verification
      result = await _verifyLocalOTP(otp);
    }

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      final success = await AuthService.signUp(widget.email, widget.password);

      if (success) {
        _showMessage('تم إنشاء الحساب بنجاح', isError: false);
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
          (route) => false,
        );
      } else {
        _showMessage('حدث خطأ أثناء إنشاء الحساب');
      }
    } else {
      _showMessage(result['message'] ?? 'رمز التحقق غير صحيح');
      _clearOTP();
    }
  }

  Future<void> _resendOTP() async {
    if (_resendCooldown > 0) return;

    setState(() => _isLoading = true);

    // Try Django first, then fallback to local
    Map<String, dynamic> result;
    try {
      result = await EmailVerificationService.sendOTP(widget.email);
    } catch (e) {
      // Generate local OTP
      result = await _generateLocalOTP();
    }

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      _showMessage('تم إرسال رمز جديد', isError: false);
      _clearOTP();
      _resendCooldown = 60;
      _startCooldownTimer();
    } else {
      _showMessage(result['message'] ?? 'فشل في إرسال الرمز');
    }
  }

  void _clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOTP();
    }
  }

  Future<Map<String, dynamic>> _verifyLocalOTP(String otp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedOTP = prefs.getString('stored_otp');
      final timestamp = prefs.getInt('otp_timestamp');
      
      if (storedOTP == null || timestamp == null) {
        return {'success': false, 'message': 'لا يوجد رمز تحقق'};
      }
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final otpAge = now - timestamp;
      const fiveMinutes = 5 * 60 * 1000;
      
      if (otpAge > fiveMinutes) {
        return {'success': false, 'message': 'انتهت صلاحية الرمز'};
      }
      
      if (storedOTP == otp) {
        return {'success': true, 'message': 'تم التحقق بنجاح'};
      } else {
        return {'success': false, 'message': 'رمز التحقق غير صحيح'};
      }
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ في التحقق'};
    }
  }

  Future<Map<String, dynamic>> _generateLocalOTP() async {
    try {
      final otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('stored_otp', otp);
      await prefs.setString('otp_email', widget.email);
      await prefs.setInt('otp_timestamp', DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('=== LOCAL OTP GENERATED ===');
      debugPrint('Email: ${widget.email}');
      debugPrint('OTP Code: $otp');
      debugPrint('Use this code in OTP screen');
      debugPrint('==========================');
      
      return {'success': true, 'message': 'تم إنشاء رمز محلي'};
    } catch (e) {
      return {'success': false, 'message': 'فشل في إنشاء الرمز'};
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? AppConstants.errorColor : AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.mark_email_read,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'تحقق من بريدك الإلكتروني',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'أدخل الرمز المكون من 6 أرقام المرسل إلى',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'رمز التحقق',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                              List.generate(6, (index) => _buildOTPField(index)),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusMedium),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'تحقق',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لم تستلم الرمز؟ ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextButton(
                              onPressed:
                                  _resendCooldown > 0 ? null : _resendOTP,
                              child: Text(
                                _resendCooldown > 0
                                    ? 'إعادة الإرسال ($_resendCooldown)'
                                    : 'إعادة الإرسال',
                                style: TextStyle(
                                  color: _resendCooldown > 0
                                      ? Colors.grey
                                      : AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: _controllers[index].text.isNotEmpty
              ? AppConstants.primaryColor
              : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }
}
