import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('المساعدة والدعم', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الأسئلة الشائعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildFAQItem('كيف أضيف وجبة جديدة؟', 'اضغط على زر + في الشاشة الرئيسية واملأ تفاصيل الوجبة'),
                  _buildDivider(),
                  _buildFAQItem('كيف أتواصل مع الطباخين؟', 'يمكنك استخدام نظام الدردشة المدمج في التطبيق'),
                  _buildDivider(),
                  _buildFAQItem('هل التطبيق آمن؟', 'نعم، نحن نستخدم أحدث تقنيات الأمان لحماية بياناتك'),
                  _buildDivider(),
                  _buildFAQItem('كيف أغير موقعي؟', 'يمكنك تحديث موقعك من إعدادات الملف الشخصي'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('تواصل معنا', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.email,
                    'البريد الإلكتروني',
                    'support@digitopia.com',
                    () => _sendEmail(),
                  ),
                  _buildDivider(),
                  _buildContactItem(
                    Icons.phone,
                    'الهاتف',
                    '+966 50 123 4567',
                    () => _makePhoneCall(),
                  ),
                  _buildDivider(),
                  _buildContactItem(
                    Icons.chat,
                    'الدردشة المباشرة',
                    'متاح 24/7',
                    () => _startLiveChat(),
                  ),
                  _buildDivider(),
                  _buildContactItem(
                    Icons.bug_report,
                    'الإبلاغ عن مشكلة',
                    'أرسل تقرير مفصل',
                    () => _reportBug(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('الموارد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildResourceItem(
                    Icons.book,
                    'دليل المستخدم',
                    'تعلم كيفية استخدام التطبيق',
                    () => _openUserGuide(),
                  ),
                  _buildDivider(),
                  _buildResourceItem(
                    Icons.video_library,
                    'فيديوهات تعليمية',
                    'شاهد الفيديوهات التوضيحية',
                    () => _openVideoTutorials(),
                  ),
                  _buildDivider(),
                  _buildResourceItem(
                    Icons.article,
                    'شروط الاستخدام',
                    'اقرأ شروط وأحكام الخدمة',
                    () => _openTermsOfService(),
                  ),
                  _buildDivider(),
                  _buildResourceItem(
                    Icons.privacy_tip,
                    'سياسة الخصوصية',
                    'تعرف على كيفية حماية بياناتك',
                    () => _openPrivacyPolicy(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildResourceItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.green, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }

  void _sendEmail() {
    // هنا يمكن إضافة منطق فتح تطبيق البريد الإلكتروني
  }

  void _makePhoneCall() {
    // هنا يمكن إضافة منطق إجراء مكالمة هاتفية
  }

  void _startLiveChat() {
    // هنا يمكن إضافة منطق بدء الدردشة المباشرة
  }

  void _reportBug() {
    // هنا يمكن إضافة منطق الإبلاغ عن الأخطاء
  }

  void _openUserGuide() {
    // هنا يمكن إضافة منطق فتح دليل المستخدم
  }

  void _openVideoTutorials() {
    // هنا يمكن إضافة منطق فتح الفيديوهات التعليمية
  }

  void _openTermsOfService() {
    // هنا يمكن إضافة منطق فتح شروط الاستخدام
  }

  void _openPrivacyPolicy() {
    // هنا يمكن إضافة منطق فتح سياسة الخصوصية
  }
}