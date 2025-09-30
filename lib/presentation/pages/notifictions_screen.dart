import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class NotifictionsScreen extends StatelessWidget {
  const NotifictionsScreen({super.key});

  // قائمة الإشعارات (يمكن ربطها بقاعدة البيانات لاحقاً)
  static final List<Map<String, dynamic>> _notifications = [];

  // إضافة إشعار جديد عند إضافة وجبة
  static void addMealNotification(String userName, String mealName) {
    _notifications.insert(0, {
      'icon': Icons.add_circle,
      'iconColor': Colors.green,
      'title': 'وجبة جديدة متاحة!',
      'subtitle': '$userName أضاف $mealName في منطقتك',
      'time': 'الآن',
      'isNew': true,
      'timestamp': DateTime.now(),
    });
  }

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
          // الإشعارات الديناميكية
          ..._notifications.map((notification) => _buildNotificationItem(
            icon: notification['icon'],
            iconColor: notification['iconColor'],
            title: notification['title'],
            subtitle: notification['subtitle'],
            time: notification['time'],
            isNew: notification['isNew'],
          )).toList(),
          // الإشعارات الثابتة
          _buildNotificationItem(
            icon: Icons.add_circle,
            iconColor: Colors.green,
            title: 'وجبة جديدة متاحة!',
            subtitle: 'سارة أحمد أضافت وجبة كبسة دجاج لذيذة في منطقتك',
            time: 'الآن',
            isNew: true,
          ),
          _buildNotificationItem(
            icon: Icons.restaurant_menu,
            iconColor: Colors.orange,
            title: 'طبق جديد قريب منك',
            subtitle: 'محمد علي أضاف مندي لحم طازج على بعد 500 متر فقط',
            time: 'منذ 3 دقائق',
            isNew: true,
          ),
          _buildNotificationItem(
            icon: Icons.message,
            iconColor: Colors.blue,
            title: 'رسالة جديدة',
            subtitle: 'لديك رسالة جديدة من فاطمة أحمد بخصوص طلب الطعام الخاص بك',
            time: 'منذ 5 دقائق',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.add_circle,
            iconColor: Colors.green,
            title: 'إضافة جديدة',
            subtitle: 'أم خالد أضافت معصوب بالعسل والموز الطازج',
            time: 'منذ 10 دقائق',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.restaurant,
            iconColor: Colors.purple,
            title: 'تم قبول طلبك',
            subtitle: 'تم قبول طلبك لـ كبسة دجاج من أم محمد يرجى التنسيق للاستلام',
            time: 'منذ 30 دقيقة',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.add_circle,
            iconColor: Colors.green,
            title: 'وجبة عشاء جديدة',
            subtitle: 'عبدالله محمد أضاف برياني دجاج بالزعفران',
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
            icon: Icons.add_circle,
            iconColor: Colors.green,
            title: 'حلويات طازجة',
            subtitle: 'نورا أحمد أضافت كنافة نابلسية بالجبن الطازج',
            time: 'منذ 3 ساعات',
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.restaurant,
            iconColor: Colors.purple,
            title: 'تم حجز طعام',
            subtitle: 'قام أحد المستفيدين بحجز طبق مولوخة مشكل الذي قمت بعرضه',
            time: 'منذ يوم',
            isNew: false,
          ),
        ],
      ),
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
        border: isNew ? Border.all(color: Colors.green.withOpacity(0.3), width: 1) : null,
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isNew ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}