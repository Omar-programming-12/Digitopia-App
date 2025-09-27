import 'package:digitopia_app/core/di/injection_container.dart' as di;
import 'package:digitopia_app/presentation/pages/auth_wrapper.dart';
import 'package:digitopia_app/services/connectivity_service.dart';
import 'package:digitopia_app/services/push_notification_service.dart';
import 'package:digitopia_app/utils/app_lifecycle_manager.dart';
import 'package:digitopia_app/utils/memory_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(PushNotificationService.firebaseMessagingBackgroundHandler);
  await PushNotificationService.init();
  
  await Supabase.initialize(
    url: 'https://hzolhiplwpycqldeudgk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6b2xoaXBsd3B5Y3FsZGV1ZGdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3MDM5MDYsImV4cCI6MjA3MzI3OTkwNn0.BeSadD1DqrSBsJEs6vR_ZbzJJvzAypE6Yk9pTIXnhe4',
  );
  
  await ConnectivityService.initialize();
  await di.init();
  
  MemoryManager.limitImageCacheSize();
  
  runApp(const DigitopiaApp());
}

class DigitopiaApp extends StatefulWidget {
  const DigitopiaApp({super.key});

  @override
  State<DigitopiaApp> createState() => _DigitopiaAppState();
}

class _DigitopiaAppState extends State<DigitopiaApp> {
  final AppLifecycleManager _lifecycleManager = AppLifecycleManager();

  @override
  void initState() {
    super.initState();
    _lifecycleManager.initialize();
  }

  @override
  void dispose() {
    _lifecycleManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digitopia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: ConnectivityService.buildConnectivityWrapper(
        child: const AuthWrapper(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
