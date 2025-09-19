import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _newMealsNotifications = true;
  bool _messagesNotifications = true;
  bool _orderUpdatesNotifications = true;
  bool _promotionsNotifications = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('إعدادات الإشعارات', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Text('أنواع الإشعارات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  _buildSwitchTile(
                    'الوجبات الجديدة',
                    'إشعارات عند إضافة وجبات جديدة في منطقتك',
                    _newMealsNotifications,
                    (value) => setState(() => _newMealsNotifications = value),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    'الرسائل',
                    'إشعارات الرسائل الجديدة',
                    _messagesNotifications,
                    (value) => setState(() => _messagesNotifications = value),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    'تحديثات الطلبات',
                    'إشعارات حالة الطلبات والحجوزات',
                    _orderUpdatesNotifications,
                    (value) => setState(() => _orderUpdatesNotifications = value),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    'العروض والخصومات',
                    'إشعارات العروض الخاصة والخصومات',
                    _promotionsNotifications,
                    (value) => setState(() => _promotionsNotifications = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('إعدادات الصوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  _buildSwitchTile(
                    'الصوت',
                    'تشغيل صوت الإشعارات',
                    _soundEnabled,
                    (value) => setState(() => _soundEnabled = value),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    'الاهتزاز',
                    'تشغيل الاهتزاز مع الإشعارات',
                    _vibrationEnabled,
                    (value) => setState(() => _vibrationEnabled = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }
}