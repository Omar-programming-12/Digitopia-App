import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  static bool _isConnected = true;

  static bool get isConnected => _isConnected;

  static Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
    
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  static void _updateConnectionStatus(ConnectivityResult result) {
    _isConnected = result != ConnectivityResult.none;
  }

  static void dispose() {
    _connectivitySubscription?.cancel();
  }

  static Widget buildConnectivityWrapper({
    required Widget child,
    Widget? noConnectionWidget,
  }) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
          return noConnectionWidget ?? _buildNoConnectionWidget();
        }
        return child;
      },
    );
  }

  static Widget _buildNoConnectionWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا يوجد اتصال بالإنترنت',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}