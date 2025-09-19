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
      print('Message data: ${message.data}');
      if(message.notification != null){
        print('Message notification: ${message.notification!.title} - ${message.notification!.body}');
      }
      
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

   
  }
   static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp();
      print('Handling a background message: ${message.messageId}');
    }
}
Future<void> printFcmToken() async {
      String? token = await FirebaseMessaging.instance.getToken();
      if(token != null){
        print("FCM Token: $token");
      } else{
        print("Token not generated yet , wait a few seconds");
      }
      
    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp();
      print('Handling a background message: ${message.messageId}');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('User opend the app from notification');
    });
    }




