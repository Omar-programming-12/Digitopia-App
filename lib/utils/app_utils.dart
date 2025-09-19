import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUtils {
  // Time formatting
  static String getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'الآن';
    
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    }
  }

  // Show snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Show loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  // Format price
  static String formatPrice(dynamic price) {
    if (price == null) return 'مجاني';
    if (price is String) {
      if (price.toLowerCase() == 'مجاني' || price.toLowerCase() == 'free') {
        return 'مجاني';
      }
      return price;
    }
    if (price is num) {
      return '$price ريال';
    }
    return 'مجاني';
  }

  // Get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'متاح':
      case 'available':
        return Colors.green;
      case 'محجوز':
      case 'reserved':
        return Colors.orange;
      case 'منتهي':
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Debounce function for search
  static void debounce(Function() action, {Duration delay = const Duration(milliseconds: 500)}) {
    Timer? timer;
    timer?.cancel();
    timer = Timer(delay, action);
  }
}

