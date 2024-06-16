// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/services/post_service.dart';

class PostDetailScreen extends StatefulWidget {
  String? name;
  final String content;
  String? img;
  final int like;
  final int reply;
  final Timestamp time;

  PostDetailScreen(
      {super.key,
      this.name,
      required this.content,
      required this.img,
      required this.like,
      required this.reply,
      // required this.imgList,
      required this.time});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      int months = difference.inDays ~/ 30;
      return '${months}mo';
    } else {
      int years = difference.inDays ~/ 365;
      return '${years}y';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avt
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.img != null
                  ? NetworkImage(widget.img!)
                  : Image.asset('assets/images/default_avt.png').image,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // account name
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name ?? '',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),

                      // time, option
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                formatTimestamp(widget.time),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/post_option.svg',
                                width: 6,
                                height: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),

                // post content
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    widget.content,
                    style: TextStyle(color: Colors.black),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}