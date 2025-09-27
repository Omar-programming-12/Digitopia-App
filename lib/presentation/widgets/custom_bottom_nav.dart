import 'package:digitopia_app/presentation/pages/chat_list_screen.dart';
import 'package:digitopia_app/presentation/pages/home_screen.dart';
import 'package:digitopia_app/presentation/pages/share_meal_screen.dart';
import 'package:flutter/material.dart';
import '../pages/profile_screen.dart';


class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            break;
          case 1:
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  ShareMealScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatListScreen()),
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'الخريطة'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'إضافة'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'المحادثات'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
      ],
    );
  }
}