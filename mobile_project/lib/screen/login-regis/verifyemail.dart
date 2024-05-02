import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/button.dart';
import 'package:flutter/material.dart';
import 'inputinfo.dart';

class VerifyEmailScreen extends StatefulWidget {
  VerifyEmailScreen({key, User? data}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  EmailOTP myauth = EmailOTP();

  final OTP1Controller = TextEditingController();
  final OTP2Controller = TextEditingController();
  final OTP3Controller = TextEditingController();
  final OTP4Controller = TextEditingController();
  final OTP5Controller = TextEditingController();
  final OTP6Controller = TextEditingController();

  void sendemailOTP() async {
    myauth.setConfig(
        appEmail: "21521956@gm.uit.edu.vn",
        appName: "Email OTP",
        userEmail: user.email,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
    }
  }

  void verifyEmail() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        });
    try {
      if (await myauth.verifyOTP(
              otp: OTP1Controller.text +
                  OTP2Controller.text +
                  OTP3Controller.text +
                  OTP4Controller.text +
                  OTP5Controller.text +
                  OTP6Controller.text) ==
          true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InputInfoScreen()));
      } else {
        Navigator.pop(context);
        ErrorMessageg();
      }
    } on FirebaseAuthException catch (e) {
      return;
    }
  }

  Future<void> ErrorMessageg() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi xác thực'),
          content:
              const Text('Mã OTP không chính xác. Hãy kiểm tra và nhập lại.'),
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
      resizeToAvoidBottomInset: false,
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
                'Mã xác thực',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Một mã xác thực vừa được gửi đến email ',
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0,
                            ),
                          ),
                          TextSpan(
                            text: user.email!,
                            style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Nhập mã xác thực để tiếp tục',
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
                      SizedBox(height: 30),

                      // OTP input
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InputCode(
                              controller: OTP1Controller,
                              first: true,
                              last: false,
                              context: context),
                          InputCode(
                              controller: OTP2Controller,
                              first: false,
                              last: false,
                              context: context),
                          InputCode(
                              controller: OTP3Controller,
                              first: false,
                              last: false,
                              context: context),
                          InputCode(
                              controller: OTP4Controller,
                              first: false,
                              last: false,
                              context: context),
                          InputCode(
                              controller: OTP5Controller,
                              first: false,
                              last: false,
                              context: context),
                          InputCode(
                              controller: OTP6Controller,
                              first: false,
                              last: true,
                              context: context),
                        ],
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // button
                      MyButton(
                        onTap: verifyEmail,
                        text: "XÁC NHẬN",
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Chưa nhận được mã? ',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(190, 0, 0, 0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                          GestureDetector(
                            onTap: sendemailOTP,
                            child: const Text(
                              'Gửi lại mã',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          //
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

class InputCode extends StatelessWidget {
  final controller;
  final bool first;
  final bool last;
  final BuildContext context;

  const InputCode(
      {Key? key,
      required this.controller,
      required this.first,
      required this.last,
      required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: AspectRatio(
        aspectRatio: 3.5 / 4.0,
        child: TextField(
          textAlignVertical: TextAlignVertical.top,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            print('$value');
          },
          showCursor: true,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          keyboardType: TextInputType.number,
          maxLength: 1,
          controller: controller,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blue),
                borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    );
  }
}
