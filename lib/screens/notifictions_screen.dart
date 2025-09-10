import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class NotifictionsScreen extends StatelessWidget {
  const NotifictionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // ---------------------------- App Bar ---------------------------- //


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('إشعارات', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://via.placeholder.com/32'),
            ),
          ),
        ],
      ),

      //------------------------------- List of Notifications -------------------------------//

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            icon: Icons.message,
            iconColor: Colors.blue,
            title: 'رسالة جديدة',
            subtitle: 'لديك رسالة جديدة من فاطمة أحمد بخصوص طلب الطعام الخاص بك',
            time: 'الآن',
            isNew: true,
          ),
          _buildNotificationItem(
            icon: Icons.restaurant,
            iconColor: Colors.purple,
            title: 'عرض طعام جديد',
            subtitle: 'أحمد علي قدم عرضاً جديداً لـ بيتزا مارجريتا',
            time: 'منذ 5 دقائق',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.notifications,
            iconColor: Colors.black,
            title: 'تحديث الحساب',
            subtitle: 'تم تحديث ملفك الشخصي بنجاح راجع التغييرات',
            time: 'منذ 30 دقيقة',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.restaurant,
            iconColor: Colors.purple,
            title: 'تم قبول طلبك',
            subtitle: 'تم قبول طلبك لـ كبسة دجاج من أم محمد يرجى التنسيق للاستلام',
            time: 'منذ ساعة',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.message,
            iconColor: Colors.blue,
            title: 'تذكير بالرد',
            subtitle: 'لا تنس الرد على رسالة محمد بخصوص حلويات شرقية',
            time: 'منذ ساعتين',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.notifications,
            iconColor: Colors.black,
            title: 'إشعار هام',
            subtitle: 'نود تذكيرك بالتحقق من إعدادات الخصوصية الخاصة بك للحفاظ على أمان بياناتك',
            time: 'منذ يوم',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.restaurant,
            iconColor: Colors.purple,
            title: 'تم حجز طعام',
            subtitle: 'قام أحد المستفيدين بحجز طبق مولوخة مشكل الذي قمت بعرضه',
            time: 'منذ يومين',
            isNew: false,
          ),
        ],
      ),

 
        // --------------------------------------- Navigation Bar --------------------------------------- //

      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),   
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isNew ? FontWeight.bold : FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}