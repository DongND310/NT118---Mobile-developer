import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:mobile_project/screen/login-regis/login.dart';

class SuccessNotiScreen extends StatelessWidget {
  const SuccessNotiScreen({super.key});

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
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 40, right: 45),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 120,
            ),
            SvgPicture.asset(
                'assets/icons/Check-Circle--Streamline-Core.svg.svg'),
            SizedBox(
              height: 50,
            ),
            Text(
              'Thành công',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Mật khẩu của bạn đã được thay đổi thành công',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                letterSpacing: 0,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            // button
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Container(
                height: 50,
                width: 340,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
