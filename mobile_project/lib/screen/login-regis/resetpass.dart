import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:mobile_project/components/button.dart';

import 'package:flutter/material.dart';
import 'successnoti.dart';

class ResetPassScreen extends StatelessWidget {
  ResetPassScreen({super.key});
  final passwordController = TextEditingController();

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
              Text(
                'Tạo mới \nmật khẩu',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Nhập mật khẩu mới',
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
                      //Email, password
                      MyTextField(
                          controller: passwordController,
                          label: "Mật khẩu mới",
                          hint: "Nhập mật khẩu mới",
                          obscureText: true),

                      MyTextField(
                          controller: passwordController,
                          label: "Nhập lại mật khẩu mới",
                          hint: "Nhập lại mật khẩu vừa tạo để xác nhận",
                          obscureText: true),
                      SizedBox(
                        height: 25,
                      ),

                      // button
                      MyButton(
                        onTap: resetPass,
                        text: "XÁC NHẬN",
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  resetPass() {}
}
