import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/components/navigation_container.dart';

class RegisterSuccessScreen extends StatelessWidget {
  RegisterSuccessScreen({super.key});
  final user = FirebaseAuth.instance.currentUser!;

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
              height: 100,
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
              'Tài khoản của bạn đã được tạo mới thành công. Đến trang chủ để khám phá thêm nhiều điều hấp dẫn!',
              textAlign: TextAlign.center,
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
            GestureDetector(
              onTap: ()
                  // => StreamBuilder(
                  //     stream: FirebaseAuth.instance.authStateChanges(),
                  //     builder: (BuildContext context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return NavigationContainer(
                  //             currentUserID: snapshot.data!.uid);
                  //       } else {
                  //         return WelcomeScreen();
                  //       }
                  //     }),

                  {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NavigationContainer(currentUserID: user.uid)));
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "ĐẾN TRANG CHỦ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
