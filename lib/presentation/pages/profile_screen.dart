import 'package:digitopia_app/presentation/pages/about_app_screen.dart';
import 'package:digitopia_app/presentation/pages/favorites_screen.dart';
import 'package:digitopia_app/presentation/pages/help_support_screen.dart';
import 'package:digitopia_app/presentation/pages/home_screen.dart';
import 'package:digitopia_app/presentation/pages/language_screen.dart';
import 'package:digitopia_app/presentation/pages/login_screen.dart';
import 'package:digitopia_app/presentation/pages/notification_settings_screen.dart';
import 'package:digitopia_app/presentation/pages/order_history_screen.dart';
import 'package:digitopia_app/presentation/pages/personal_info_screen.dart';
import 'package:digitopia_app/presentation/pages/privacy_security_screen.dart';
import 'package:digitopia_app/presentation/pages/ratings_screen.dart';
import 'package:digitopia_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreenContent();
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('الملف الشخصي', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.push(context , MaterialPageRoute(builder: (context) => HomeScreen())),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://via.placeholder.com/100'),
                  ),
                  const SizedBox(height: 16),
                  const Text('سارة أحمد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('sarah.ahmed@email.com', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Text('الرياض، السعودية', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  _buildProfileItem(Icons.person, 'المعلومات الشخصية', '', () => _navigateToScreen(context, const PersonalInfoScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.favorite, 'المفضلة', '12 وجبة', () => _navigateToScreen(context, const FavoritesScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.history, 'سجل الطلبات', '25 طلب', () => _navigateToScreen(context, const OrderHistoryScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.star, 'التقييمات', '4.8', () => _navigateToScreen(context, const RatingsScreen())),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  _buildProfileItem(Icons.notifications, 'الإشعارات', '', () => _navigateToScreen(context, const NotificationSettingsScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.security, 'الخصوصية والأمان', '', () => _navigateToScreen(context, const PrivacySecurityScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.language, 'اللغة', 'العربية', () => _navigateToScreen(context, const LanguageScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.help, 'المساعدة والدعم', '', () => _navigateToScreen(context, const HelpSupportScreen())),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  _buildProfileItem(Icons.info, 'حول التطبيق', '', () => _navigateToScreen(context, const AboutAppScreen())),
                  _buildDivider(),
                  _buildProfileItem(Icons.logout, 'تسجيل الخروج', '', () => _showLogoutDialog(context), isLogout: true),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.blue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      subtitle: subtitle.isNotEmpty ? Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ) : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 60,
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}