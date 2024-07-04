import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_project/screen/login-regis/welcome.dart';
import 'package:mobile_project/screen/message/chat_page.dart';
import 'firebase_options.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'chats',
    'Reels Replay',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    enableVibration: true,
    channelShowBadge: true,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBDryibj-98tAmkyJcC7J0qjyqwIoL60-I',
          appId: '1:402679655358:android:360da8ee3356bd94ce27ef',
          messagingSenderId: '402679655358',
          projectId: 'nt118-reelreplay'))
      : await Firebase.initializeApp(
    name: "Reels Replay",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'Your channel description',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Reels Replay',
    allowBubbles: true,
    enableVibration: true,
    enableSound: true,
    showBadge: true,);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //
  // });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      final receiverId = message.data['receiverId'];
      final receiverName = message.data['receiverName'];
      final chatterImg = message.data['chatterImg'];
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            receiverId: receiverId,
            receiverName: receiverName,
            chatterImg: chatterImg,
          ),
        ),
      );
    }
  }
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleMessage(message);
  });


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget getScreenID() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return NavigationContainer(
              currentUserID: snapshot.data!.uid,
              pageIndex: 0,
            );
          } else {
            return const WelcomeScreen();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      home: getScreenID(),
      navigatorKey: navigatorKey,
    );
  }
}