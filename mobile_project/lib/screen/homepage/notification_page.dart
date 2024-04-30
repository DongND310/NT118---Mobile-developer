import 'package:flutter/material.dart';
import 'package:mobile_project/components/custom_follow_notification.dart';
import 'package:mobile_project/components/custom_liked_notification.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  List Item = [
    "liked",
    "follow",
    "liked",
    "liked",
    "follow",
    "liked",
    "liked",
    "liked",
    "liked",
    "liked",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Thông báo",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter",
                ),
          ),
        ),
        titleTextStyle: null,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xff0000D7), Color(0xff0BA9FF)]),
          ),
        ),
      ),
      //Nội dung hiển thị
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Item.length,
                itemBuilder: (context, index) {
                  return Item[index] == "follow"
                      ? CustomFollowNotification()
                      : CustomLikedNotification();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
