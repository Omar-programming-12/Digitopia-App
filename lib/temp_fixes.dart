// Temporary fixes and workarounds
// TODO: replace these with proper solutions

import 'package:flutter/material.dart';

class TempFixes {
  // Quick fix for image loading issues
  static Widget imageWithFallback(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: Icon(Icons.image_not_supported),
      );
    }
    
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        print('Image failed to load: $error'); // TODO: proper logging
        return Container(
          color: Colors.grey[300],
          child: Icon(Icons.broken_image),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  
  // Hack for navigation - doesn't work properly
  static void navigateToHome(BuildContext context) {
    try {
      // Navigator.pushReplacementNamed(context, '/home');
      print('Navigation not implemented yet');
    } catch (e) {
      print('Navigation failed: $e');
    }
  }
  
  // Quick validation - very basic
  static bool isEmailValid(String email) {
    return email.contains('@') && email.contains('.');
  }
  
  // Temporary user data - hardcoded
  static Map<String, String> getCurrentUser() {
    return {
      'name': 'Test User',
      'email': 'test@example.com',
      'id': '12345'
    };
  }
  
  // Error handling - just prints for now
  static void handleError(dynamic error) {
    print('Error occurred: $error');
    // TODO: show proper error dialog
  }
  
  // Loading state - basic implementation
  static Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...'), // TODO: localize
        ],
      ),
    );
  }
}

// Constants that should be in a proper config file
class TempConstants {
  static const String APP_NAME = 'Digitopia'; // TODO: get from config
  static const String DEFAULT_ERROR = 'Something went wrong';
  static const String NO_INTERNET = 'No internet connection';
  
  // Colors - randomly chosen
  static const Color PRIMARY_COLOR = Colors.blue;
  static const Color ERROR_COLOR = Colors.red;
  static const Color SUCCESS_COLOR = Colors.green;
}

// Debug helpers - remove in production
class DebugHelpers {
  static void logUserAction(String action) {
    print('USER ACTION: $action');
  }
  
  static void logError(String error) {
    print('ERROR: $error');
  }
  
  static void logInfo(String info) {
    print('INFO: $info');
  }
}