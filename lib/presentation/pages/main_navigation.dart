import 'package:digitopia_app/presentation/pages/chat_list_screen.dart';
import 'package:digitopia_app/presentation/pages/home_screen.dart';
import 'package:digitopia_app/presentation/pages/map_screen.dart';
import 'package:digitopia_app/presentation/pages/share_meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:digitopia_app/constants/app_constants.dart';
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
      duration: AppConstants.animationMedium,
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

  final List<Widget> _pages = [
    const HomeScreen(),
    const MapScreen(),
     ShareMealScreen(),
    const ChatListScreenContent(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      _pageAnimationController.reset();
      setState(() {
        _currentIndex = index;
      });
      _pageAnimationController.forward();
    }
  }
  
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return AnimatedContainer(
      duration: AppConstants.animationFast,
      padding: EdgeInsets.all(isSelected ? 8 : 4),
      decoration: BoxDecoration(
        color: isSelected ? AppConstants.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: isSelected ? 26 : 24),
    );
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
                children: _pages,
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
          selectedItemColor: AppConstants.primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
          items: List.generate(5, (index) => BottomNavigationBarItem(
            icon: _buildNavItem(index, iconList[index], labelList[index]),
            label: labelList[index],
          )),
        ),
      ),
    );
  }
}