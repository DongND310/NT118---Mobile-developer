import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:mobile_project/components/button.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/screen/login-regis/login.dart';

class ForgotPassScreen extends StatefulWidget {
  ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future forgotPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Link reset mật khẩu đã được gửi đến email ' +
                  emailController.text.trim() +
                  '. Hãy kiểm tra email và thay đổi mật khẩu.',
              style: TextStyle(fontSize: 15),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "XÁC NHẬN",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
      wrongMessage(e.code);
    }
  }

  void wrongMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(errorMessage),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
            padding: const EdgeInsets.only(top: 0.0, left: 40, right: 45),
            children: [
              const Text(
                'Quên mật khẩu',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Nhập địa chỉ email để nhận mã xác thực',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      //Email, password

                      MyTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Nhập email người dùng",
                          obscureText: false),
                      const SizedBox(
                        height: 35,
                      ),

                      // button
                      MyButton(
                        onTap: forgotPassword,
                        text: "TIẾP TỤC",
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
