import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:mobile_project/components/button.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/navigation_container.dart';
import 'package:mobile_project/services/auth_service.dart';
import 'forgotpass.dart';
import 'signup.dart';
import 'welcome.dart';
import 'package:mobile_project/screen/homepage/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      Navigator.pop(context);

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NavigationContainer(currentUserID: currentUser.uid),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;
      print(e.code);
      switch (e.code) {
        case 'R-email':
          errorMessage = 'Email không hợp lệ.';
          break;
        case 'invalid-credential':
          errorMessage = 'Thông tin đăng nhập tài khoản không đúng.';
          break;
        case 'channel-error':
          errorMessage = 'Lỗi xảy ra trong quá trình đăng nhập.';
          break;
        case 'network-request-failed':
          errorMessage = 'Lỗi kết nối mạng.';
          break;
        default:
          errorMessage = e.message ?? 'Lỗi xảy ra trong quá trình đăng nhập.';
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
          title: const Text('Lỗi đăng nhập'),
          content: Text('$errorMessage Hãy kiểm tra và đăng nhập lại.'),
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
                'Chào mừng!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Đăng nhập để tiếp tục',
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
                      //Email, password
                      MyTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Nhập email người dùng",
                       ),
                      MyTextField(
                          controller: passwordController,
                          label: "Password",
                          hint: "Nhập mật khẩu",
                          obscureText: true),

                      const SizedBox(
                        height: 15,
                      ),

                      //remember - forgot pass
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassScreen()));
                              },
                              child: const Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ]),
                      const SizedBox(height: 15),

                      // login button
                      MyButton(
                        onTap: signUserIn,
                        text: "ĐĂNG NHẬP",
                      ),
                      const SizedBox(height: 30),

                      // login gg
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
                        onTap: () {
                          AuthService().signInWithGoogle();
                          StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasData) {
                                  return NavigationContainer(
                                      currentUserID: snapshot.data!.uid);
                                } else {
                                  return WelcomeScreen();
                                }
                              });
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => NavigationContainer(
                          //             currentUserID: snapshot.data!.uid)));
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
                                offset: Offset(0, 3),
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
                                  "Đăng nhập với Google",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(190, 0, 0, 0),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0),
                                ),
                              ]),
                        ),
                      ),

                      // sign up
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Chưa có tài khoản? ',
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
                                      builder: (context) => SignUpScreen()));
                            },
                            child: const Text(
                              'Đăng ký',
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
