import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        color: Colors.white,
        height: 300,
        child: Stack(
          children: [
            Positioned(
                top: 8,
                left: 155,
                child: Container(width: 90, height: 4, color: Colors.grey)),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 300,
                      child: TextField(
                        controller: comment,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: "Thêm bình luận",
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(onTap: () {}, child: Icon(Icons.send)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
