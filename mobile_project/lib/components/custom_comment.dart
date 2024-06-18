import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomComment extends StatefulWidget {
  final String name;
  final String? img;
  final String content;
  final int like;
  final int reply;
  final Timestamp time;

  const CustomComment(
      {super.key,
      required this.name,
      this.img,
      required this.content,
      required this.like,
      required this.reply,
      required this.time});

  @override
  State<CustomComment> createState() => _CustomCommentState();
}

class _CustomCommentState extends State<CustomComment> {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // avt
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // account name
                Text(
                  widget.name ?? '',
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),

                const SizedBox(height: 5),

                // post content
                SizedBox(
                  width: 320,
                  child: Text(
                    widget.content,
                    style: const TextStyle(color: Colors.black),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            formatTimestamp(widget.time),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {},
                            child: const Text("Trả lời",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/heart.svg',
                            width: 15,
                            color: Colors.grey,
                          ),
                          Text(
                            " ${widget.like}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ]),
                const SizedBox(height: 10),

                // like, reply
                Row(
                  children: [
                    const Text(
                      '----',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Xem ${widget.reply} câu trả lời',
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
