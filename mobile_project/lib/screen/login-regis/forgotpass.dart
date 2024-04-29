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
              style: const TextStyle(fontSize: 15),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ.';
          break;
        case 'invalid-credential':
          errorMessage = 'Email không tồn tại.';
          break;
        case 'channel-error':
          errorMessage = 'Lỗi xảy ra trong quá trình cập nhật mật khẩu.';
          break;
        default:
          errorMessage = e.message ?? 'Lỗi xảy ra.';
      }
      ErrorMessageg(errorMessage);
      return;
    }
  }

  Future<void> ErrorMessageg(String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi:'),
          content: Text('$errorMessage Hãy kiểm tra và nhập lại.'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      //Email input
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
