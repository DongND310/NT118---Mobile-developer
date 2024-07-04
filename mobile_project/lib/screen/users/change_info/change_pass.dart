import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:mobile_project/components/button.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/screen/login-regis/login.dart';

class PassChangeScreen extends StatefulWidget {
  PassChangeScreen({super.key});

  @override
  State<PassChangeScreen> createState() => _PassChangeScreenState();
}

class _PassChangeScreenState extends State<PassChangeScreen> {
  @override
  void initState() {
    forgotPassword();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future forgotPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email ?? "");
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text(
          'Mật khẩu tài khoản',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
            padding: const EdgeInsets.only(top: 40.0, left: 30, right: 20),
            children: [
              Expanded(
                  flex: 3,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Link reset mật khẩu đã được gửi đến email ",
                          style: TextStyle(
                            height: 1.8,
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: '${user.email}',
                          style: const TextStyle(
                            height: 1.8,
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ". Hãy kiểm tra email và thay đổi mật khẩu của bạn.",
                          style: TextStyle(
                            height: 1.8,
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  )),
            ]),
      ),
    );
  }
}
