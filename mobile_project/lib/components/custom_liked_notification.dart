import 'package:flutter/material.dart';

class CustomLikedNotification extends StatelessWidget {
  const CustomLikedNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: const SizedBox(
              height: 80,
              width: 80,
              child: Stack(alignment: Alignment.topRight, children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30, top: 20, bottom: 10),
                  child: Positioned(
                    bottom: 15,
                    child: CircleAvatar(
                      radius: 25,
                      // backgroundColor: Colors.purple,
                      backgroundImage: AssetImage("assets/images/disc.png"),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Account Tester2",
                                style: TextStyle(
                                  height: 1,
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " và ",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: "Account Tester3",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: " đã thích bài đăng của bạn.",
                                style: const TextStyle(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
