import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/homepage/homepage.dart';
import 'login.dart';
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

  void signUserUp() async {
    // var errorMessage;
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
            MaterialPageRoute(
                builder: (context) => InputInfoScreen(
                      email: emailController.text,
                    )));
      } else {
        wrongMessage("Mật khẩu không trùng khớp.");
      }

      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      wrongMessage(e.code);
    }
  }

  void wrongMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(errorMessage),
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
              Text(
                'Xin chào!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Tạo tài khoản mới',
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
                      SizedBox(height: 20),

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

                      SizedBox(
                        height: 30,
                      ),

                      MyButton(
                        onTap: signUserUp,
                        text: "ĐĂNG KÝ",
                      ),
                      SizedBox(height: 40),

                      // signup gg/fb
                      Text(
                        'Hoặc đăng ký với',
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(190, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 110,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.5,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image(
                                    image: AssetImage('assets/images/gg.png')),
                              ),
                              Container(
                                width: 110,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.5,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image(
                                    image: AssetImage('assets/images/fb.png')),
                              ),
                            ]),
                      ),

                      // login
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã có tài khoản? ',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(190, 0, 0, 0),
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
                            child: Text(
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
