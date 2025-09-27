import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MemoryManager {
  static void optimizeMemory() {
    if (!kDebugMode) {
      try {
        ProcessInfo.currentRss;
      } catch (e) {
        debugPrint('Memory optimization not available on this platform');
      }
    }
  }

  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  static void limitImageCacheSize() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB
  }

  static void printMemoryUsage() {
    if (kDebugMode) {
      try {
        final rss = ProcessInfo.currentRss;
        debugPrint('Current memory usage: ${(rss / 1024 / 1024).toStringAsFixed(2)} MB');
      } catch (e) {
        debugPrint('Memory info not available');
      }
    }
  }
}