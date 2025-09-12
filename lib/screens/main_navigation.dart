import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'share_meal_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _pageAnimationController;
  late Animation<double> pageAnimation;
  late CurvedAnimation pageCurve;

  final List<IconData> iconList = [
    Icons.home,
    Icons.map,
    Icons.add_circle,
    Icons.chat,
    Icons.person,
  ];

  final List<String> labelList = [
    'الرئيسية',
    'الخريطة',
    'إضافة',
    'المحادثات',
    'الملف الشخصي',
  ];

  @override
  void initState() {
    super.initState();
    
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    pageCurve = CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOut,
    );

    pageAnimation = Tween<double>(begin: 0, end: 1).animate(pageCurve);

    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const MapScreen();
      case 2:
        return const ShareMealScreen();
      case 3:
        return const ChatListScreenContent();
      case 4:
        return const ProfileScreenContent();
      default:
        return const HomeScreen();
    }
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      _pageAnimationController.reset();
      setState(() {
        _currentIndex = index;
      });
      _pageAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: pageAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.95 + (0.05 * pageAnimation.value),
            child: Opacity(
              opacity: 0.7 + (0.3 * pageAnimation.value),
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _getPage(0),
                  _getPage(1),
                  _getPage(2),
                  _getPage(3),
                  _getPage(4),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.5,
              blurRadius: 12,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_currentIndex == 0 ? 8 : 4),
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.home, size: _currentIndex == 0 ? 26 : 24),
              ),
              label: labelList[0],
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_currentIndex == 1 ? 8 : 4),
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.map, size: _currentIndex == 1 ? 26 : 24),
              ),
              label: labelList[1],
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_currentIndex == 2 ? 8 : 4),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add_circle, size: _currentIndex == 2 ? 26 : 24),
              ),
              label: labelList[2],
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_currentIndex == 3 ? 8 : 4),
                decoration: BoxDecoration(
                  color: _currentIndex == 3 ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.chat, size: _currentIndex == 3 ? 26 : 24),
              ),
              label: labelList[3],
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_currentIndex == 4 ? 8 : 4),
                decoration: BoxDecoration(
                  color: _currentIndex == 4 ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person, size: _currentIndex == 4 ? 26 : 24),
              ),
              label: labelList[4],
            ),
          ],
        ),
      ),
    );
  }
}