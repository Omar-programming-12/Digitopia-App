import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  static const Duration _defaultTimeout = Duration(seconds: 10);
  static const int _maxRetries = 3;

  static Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<http.Response?> getWithRetry(
    String url, {
    Map<String, String>? headers,
    Duration timeout = _defaultTimeout,
    int maxRetries = _maxRetries,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        if (!await hasInternetConnection()) {
          throw const SocketException('No internet connection');
        }

        final response = await http.get(
          Uri.parse(url),
          headers: headers,
        ).timeout(timeout);

        if (response.statusCode == 200) {
          return response;
        }
      } catch (e) {
        debugPrint('Network request attempt ${attempt + 1} failed: $e');
        if (attempt == maxRetries - 1) {
          rethrow;
        }
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }
    return null;
  }

  static Future<http.Response?> postWithRetry(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Duration timeout = _defaultTimeout,
    int maxRetries = _maxRetries,
  }) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        if (!await hasInternetConnection()) {
          throw const SocketException('No internet connection');
        }

        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        ).timeout(timeout);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
      } catch (e) {
        debugPrint('Network request attempt ${attempt + 1} failed: $e');
        if (attempt == maxRetries - 1) {
          rethrow;
        }
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }
    return null;
  }
}