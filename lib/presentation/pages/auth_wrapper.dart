import 'package:digitopia_app/presentation/pages/login_screen.dart';
import 'package:digitopia_app/presentation/pages/main_navigation.dart';
import 'package:digitopia_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.checkLoginState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final isLoggedIn = snapshot.data ?? false;
        return isLoggedIn ? const MainNavigation() : const LoginScreen();
      },
    );
  }
}