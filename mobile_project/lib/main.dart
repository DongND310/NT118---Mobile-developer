import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_project/screen/login-regis/welcome.dart';
import 'firebase_options.dart';

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
      // home: WelcomeScreen(),

      home: getScreenID(),
    );
  }
}
