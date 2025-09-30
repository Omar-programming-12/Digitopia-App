import 'package:digitopia_app/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isLoading = false;
  bool _isEmailVerified = false;
  Timer? _timer;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    
    if (!_isEmailVerified) {
      _sendEmailVerification();
      _startEmailVerificationCheck();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _sendEmailVerification() async {
    try {
      setState(() => _isLoading = true);
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _showMessage('تم إرسال رابط التحقق إلى ${user.email}', isError: false);
        _startResendCooldown();
      }
    } catch (e) {
      _showMessage('فشل في إرسال رابط التحقق');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        setState(() => _isEmailVerified = true);
        _timer?.cancel();
        _showMessage('تم التحقق من البريد الإلكتروني بنجاح! 🎉', isError: false);
        
        // العودة للشاشة السابقة بعد ثانيتين
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true);
      }
    }
  }

  void _startResendCooldown() {
    _resendCooldown = 60; // دقيقة واحدة
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? AppConstants.errorColor : AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppConstants.primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildVerificationCard(user?.email ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            _isEmailVerified ? Icons.mark_email_read_rounded : Icons.mark_email_unread_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isEmailVerified ? 'تم التحقق بنجاح!' : 'تحقق من بريدك الإلكتروني',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCard(String email) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!_isEmailVerified) ...[
            const Icon(
              Icons.email_outlined,
              size: 80,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(height: 20),
            const Text(
              'تم إرسال رابط التحقق إلى:',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                children: [
                  Icon(Icons.info_outline, color: AppConstants.primaryColor),
                  SizedBox(height: 8),
                  Text(
                    'افتح بريدك الإلكتروني واضغط على رابط التحقق',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _resendCooldown > 0 ? null : _sendEmailVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        _resendCooldown > 0 
                            ? 'إعادة الإرسال خلال $_resendCooldown ثانية'
                            : 'إعادة إرسال رابط التحقق',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      await _checkEmailVerified();
                    },
                    child: const Text(
                      'تحققت بالفعل؟ اضغط هنا',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ] else ...[
            const Icon(
              Icons.check_circle,
              size: 100,
              color: AppConstants.successColor,
            ),
            const SizedBox(height: 20),
            const Text(
              'تم التحقق من بريدك الإلكتروني بنجاح!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.successColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'يمكنك الآن استخدام جميع مميزات التطبيق',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}