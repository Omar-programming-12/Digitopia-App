import 'package:flutter/material.dart';
import 'package:digitopia_app/utils/memory_manager.dart';
import 'package:digitopia_app/utils/cache_manager.dart';

class AppLifecycleManager extends WidgetsBindingObserver {
  static final AppLifecycleManager _instance = AppLifecycleManager._internal();
  factory AppLifecycleManager() => _instance;
  AppLifecycleManager._internal();

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onAppPaused() {
    MemoryManager.optimizeMemory();
    debugPrint('App paused - memory optimized');
  }

  void _onAppResumed() {
    debugPrint('App resumed');
  }

  void _onAppDetached() {
    MemoryManager.clearImageCache();
    debugPrint('App detached - cache cleared');
  }
}