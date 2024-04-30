import 'package:flutter/material.dart';

class CustomLikedNotification extends StatelessWidget {
  const CustomLikedNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 80,
          width: 80,
          child: Stack(children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
            ),
            Positioned(
              bottom: 10,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/images/disc.png"),
              ),
            ),
          ]),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                    text: "Account Tester2",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                    children: [
                      TextSpan(
                        text: " và ",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                      ),
                      const TextSpan(text: "Account Tester3")
                    ]),
              ),
              const SizedBox(
                height: 5,
              ),
              Text("đã thích bài đăng của bạn.",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.grey,
                        fontSize: 10,
                      ))
            ],
          ),
        ),
      ],
    );
  }
}
