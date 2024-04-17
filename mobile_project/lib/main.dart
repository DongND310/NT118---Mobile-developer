import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/screen/welcome.dart';

import 'package:mobile_project/screen/inputinfor.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      home: const InputInfoScreen(),
    );
  }
}
