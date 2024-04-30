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
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/images/avatar.png"),
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Account Tester 1",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.black, fontSize: 15),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "đã bắt đầu theo dõi bạn.",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: follow == false ? 50 : 30),
            child: CustomButton(
              height: 40,
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
