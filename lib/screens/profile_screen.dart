import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // ---------------------------- App Bar ---------------------------- //


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('الملف الشخصي', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      //------------------------------- Profile Info and Options -------------------------------//

      
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
                  _buildProfileItem(Icons.person, 'المعلومات الشخصية', ''),
                  _buildDivider(),
                  _buildProfileItem(Icons.favorite, 'المفضلة', '12 وجبة'),
                  _buildDivider(),
                  _buildProfileItem(Icons.history, 'سجل الطلبات', '25 طلب'),
                  _buildDivider(),
                  _buildProfileItem(Icons.star, 'التقييمات', '4.8'),
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
                  _buildProfileItem(Icons.notifications, 'الإشعارات', ''),
                  _buildDivider(),
                  _buildProfileItem(Icons.security, 'الخصوصية والأمان', ''),
                  _buildDivider(),
                  _buildProfileItem(Icons.language, 'اللغة', 'العربية'),
                  _buildDivider(),
                  _buildProfileItem(Icons.help, 'المساعدة والدعم', ''),
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
                  _buildProfileItem(Icons.info, 'حول التطبيق', ''),
                  _buildDivider(),
                  _buildProfileItem(Icons.logout, 'تسجيل الخروج', '', isLogout: true),
                ],
              ),
            ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle, {bool isLogout = false}) {
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
      onTap: () {},
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
}