import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  static Future<void> init() async {
    await _fcm.requestPermission();


    String? token = await _fcm.getToken();
    print('FCM Token: $token');


    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print('Got a message in foreground');
      if(message.notification != null){
        print("Title: ${message.notification!.title}");
        print('Body: ${message.notification!.body}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('User opend the app from notification');
    });


   
  }
   static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp();
      print('Handling a background message: ${message.messageId}');
    }
}
