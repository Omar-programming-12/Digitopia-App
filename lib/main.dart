import 'package:digitopia_app/constants/app_constants.dart';
import 'package:digitopia_app/services/connectivity_service.dart';
import 'package:digitopia_app/services/push_notification_service.dart';
import 'package:digitopia_app/services/storage_service.dart';
import 'package:digitopia_app/utils/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/main_navigation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await StorageService.initialize();
    await ConnectivityService.initialize();
    
    await Firebase.initializeApp();
    printFcmToken();
    FirebaseMessaging.onBackgroundMessage(PushNotificationService.firebaseMessagingBackgroundHandler);
    await PushNotificationService.init();
    
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('خطأ في التهيئة: $e');
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: ConnectivityService.buildConnectivityWrapper(
        child: const MainNavigation(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


// FCM token for teest = dvAFgQoaQwq285waRBDa5A:APA91bFZXtkxiJX_VPD5QVN6ASqLncUnzVpagDMAEwwdJjlSi3wA8Z7lsI4WP_Ptz659VDy3ehsJAyXM7OSSxL2RZHzyqSx3sYRArc1c_4xCFlE6YPQA6YE

