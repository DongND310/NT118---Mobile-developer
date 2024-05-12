// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDetailScreen extends StatefulWidget {
  final String name;
  final String content;
  final String? img;
  final int like;
  final int reply;
  final List<String> imgList;
  final Timestamp time;

  PostDetailScreen(
      {super.key,
      required this.name,
      required this.content,
      required this.img,
      required this.like,
      required this.reply,
      required this.imgList,
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
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avt
          Padding(
            padding: EdgeInsets.only(top: 10),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // account name
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: 230,
                  child: Text(
                    widget.name ?? '',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                SizedBox(width: 5),

                // time, option
                Row(
                  children: [
                    Container(
                      width: 40,
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
              ]),

              // post content
              Container(
                width: 300,
                child: Text(
                  widget.content,
                  style: TextStyle(color: Colors.black),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 10),

              // img
              Container(
                width: 325,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.imgList.length,
                      (index) => Container(
                        margin: EdgeInsets.only(right: 5),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: widget.imgList[index] != null
                              ? Image.network(
                                  widget.imgList[index],
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // interact icon
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/post_like.svg',
                    width: 22,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 18),
                  SvgPicture.asset(
                    'assets/icons/post_cmt.svg',
                    width: 22,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 18),
                  SvgPicture.asset(
                    'assets/icons/post_repost.svg',
                    width: 22,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // like, reply
              Row(
                children: [
                  Text(
                    '${widget.like} lượt thích',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '${widget.reply} lượt phản hồi',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
