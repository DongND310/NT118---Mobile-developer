import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/components/button.dart';
import 'package:flutter/material.dart';

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
            const SizedBox(
              height: 120,
            ),
            SvgPicture.asset(
                'assets/icons/Check-Circle--Streamline-Core.svg.svg'),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Thành công',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Mật khẩu của bạn đã được thay đổi thành công',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            // button
            MyButton(
              onTap: resetPassSuccess,
              text: "ĐĂNG NHẬP",
            ),
          ]),
        ),
      ),
    );
  }

  resetPassSuccess() {}
}
