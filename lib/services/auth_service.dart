import 'package:digitopia_app/utils/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  static User? get currentUser => _auth.currentUser;
  static bool get isLoggedIn => _auth.currentUser != null;

  static Future<bool> signIn(String email, String password) async {
    try {
      debugPrint('Attempting to sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        debugPrint('Sign in successful for user: ${credential.user!.uid}');
        await _saveLoginState(true, email);
        await SecureStorage.saveUserId(credential.user!.uid);
        await SecureStorage.saveLastLogin();
        return true;
      }
      debugPrint('Sign in failed: credential.user is null');
      return false;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    try {
      debugPrint('Attempting to create account with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        debugPrint('Account created successfully for user: ${credential.user!.uid}');
        await _saveLoginState(true, email);
        await SecureStorage.saveUserId(credential.user!.uid);
        await SecureStorage.saveLastLogin();
        return true;
      }
      debugPrint('Sign up failed: credential.user is null');
      return false;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _saveLoginState(false, '');
      await SecureStorage.clearAll();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  static Future<void> _saveLoginState(bool isLoggedIn, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
    await prefs.setString(_userEmailKey, email);
  }

  static Future<bool> checkLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final currentUser = _auth.currentUser;
      debugPrint('Checking login state - SharedPrefs: $isLoggedIn, Firebase User: ${currentUser != null}');
      return isLoggedIn && currentUser != null;
    } catch (e) {
      debugPrint('Error checking login state: $e');
      return false;
    }
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? '';
  }
}