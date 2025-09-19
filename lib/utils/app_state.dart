import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = false;
  String _currentLocation = 'الرياض - الدخل';
  String _currentUser = 'سارة';
  int _notificationCount = 3;

  bool get isLoading => _isLoading;
  String get currentLocation => _currentLocation;
  String get currentUser => _currentUser;
  int get notificationCount => _notificationCount;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  void updateUser(String user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateNotificationCount(int count) {
    _notificationCount = count;
    notifyListeners();
  }

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }
}