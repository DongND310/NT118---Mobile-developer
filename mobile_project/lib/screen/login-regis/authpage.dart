import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/screen/login-regis/welcome.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // is logged
          if (snapshot.hasData) {
            return NavigationContainer(currentUserID: snapshot.data!.uid, pageIndex: 0,);
          }

          // not logged
          else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
