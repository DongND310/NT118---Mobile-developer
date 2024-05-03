import 'package:flutter/material.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/screen/homepage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_project/screen/login-regis/welcome.dart';
import 'package:mobile_project/screen/message/message_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      home: WelcomeScreen(),
      //home: NavigationContainer(),
    );
  }
}
