import 'package:flutter/material.dart';

class CustomLikedNotification extends StatelessWidget {
  const CustomLikedNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 10,bottom: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/avatar.png"),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Account Tester1",
                            style: TextStyle(
                              height: 1,
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " đã thích bài đăng của bạn.",
                            style: TextStyle(
                              height: 1.2,
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ]));
  }
}
