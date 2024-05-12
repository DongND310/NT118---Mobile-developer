import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/services/auth_service.dart';
import 'login.dart';
import 'verifyemail.dart';
import 'welcome.dart';
import 'inputinfo.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:mobile_project/components/button.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  EmailOTP myauth = EmailOTP();

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        });
    try {
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
            MaterialPageRoute(builder: (context) => InputInfoScreen()));
      } else {
        Navigator.pop(context);
        ErrorMessageg("Mật khẩu không trùng khớp.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;
      print(e.code);
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email đã được đăng ký.';
          break;
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ.';
          break;
        case 'invalid-credential':
          errorMessage = 'Thông tin tài khoản không đúng.';
          break;
        case 'channel-error':
          errorMessage = 'Lỗi xảy ra trong quá trình đăng ký.';
          break;
        case 'network-request-failed':
          errorMessage = 'Lỗi kết nối mạng.';
          break;
        default:
          errorMessage = e.message ?? 'Lỗi xảy ra trong quá trình đăng ký.';
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
          title: const Text('Lỗi đăng ký'),
          content: Text('$errorMessage Hãy kiểm tra và nhập lại.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.blue)),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()));
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
                'Xin chào!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Tạo tài khoản mới',
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

                      MyTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Nhập email người dùng",
                          obscureText: false),

                      MyTextField(
                          controller: passwordController,
                          label: "Mật khẩu",
                          hint: "Nhập mật khẩu",
                          obscureText: true),

                      MyTextField(
                          controller: confirmpasswordController,
                          label: "Nhập lại mật khẩu",
                          hint: "Nhập lại mật khẩu để xác nhận",
                          obscureText: true),

                      const SizedBox(
                        height: 30,
                      ),

                      MyButton(
                        onTap: signUserUp,
                        text: "ĐĂNG KÝ",
                      ),
                      const SizedBox(height: 30),

                      // signup gg/fb
                      const Text(
                        'Hoặc',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(190, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          // AuthService().signInWithGoogle();
                          var userCredential =
                              await AuthService().signInWithGoogle();
                          var email = userCredential.user!.email;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InputInfoScreen()));
                        },
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/google_logo.svg",
                                  width: 35,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "Đăng ký với Google",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(190, 0, 0, 0),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0),
                                ),
                              ]),
                        ),
                      ),

                      // login
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Đã có tài khoản? ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(190, 0, 0, 0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ],
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
