import 'package:flutter/material.dart';
import 'package:mobile_project/components/custom_button.dart';

class CustomFollowNotification extends StatefulWidget {
  const CustomFollowNotification({super.key});

  @override
  State<CustomFollowNotification> createState() =>
      _CustomFollowNotificationState();
}

class _CustomFollowNotificationState extends State<CustomFollowNotification> {
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Container(
          width: 160,
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
                            text: "Account Tester1",
                            style: TextStyle(
                              height: 1,
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " đã bắt đầu theo dõi bạn.",
                            style: const TextStyle(
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
          ),
        ),
        Container(
          width: 100,
          height: 80,
          child: Padding(
            // padding: EdgeInsets.only(left: follow == false ? 50 : 30),
            padding: EdgeInsets.only(left: 5),
            child: CustomButton(
              height: 45,
              color: follow == false ? Colors.blue : const Color(0xffF1FCFD),
              textColor: follow == false ? Colors.white : Colors.black,
              onTap: () => {
                setState(() {
                  follow = !follow;
                })
              },
              text: follow == false ? "Follow" : "Followed",
            ),
          ),
        ),
      ],
    );
  }
}
