import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class DeleteSubReply extends StatefulWidget {
  DeleteSubReply(
      {super.key,
      required this.id,
      required this.userId,
      required this.cmtId,
      required this.subreplyId});
  final String id;
  final String cmtId;
  final String userId;
  final String subreplyId;
  @override
  State<DeleteSubReply> createState() => _DeleteSubReplyState();
}

class _DeleteSubReplyState extends State<DeleteSubReply> {
  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Cảnh báo!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Bạn có chắc chắn muốn xóa bình luận này không?',
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Xóa',
                        style: TextStyle(color: Colors.red, fontSize: 17)),
                    onPressed: () async {
                      // Navigator.pop(context);

                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.id)
                          .collection('replies')
                          .doc(widget.cmtId)
                          .collection('subreplies')
                          .doc(widget.subreplyId)
                          .delete()
                          .then((value) => print("đã xóa subcomment"))
                          .catchError(
                              (error) => print("lỗi xóa subcomment: $error"));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  child: const Text('Hủy',
                      style: TextStyle(color: Colors.blue, fontSize: 17)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        color: Colors.black.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: GestureDetector(
          onTap: deletePost,
          child: Container(
            alignment: Alignment.center,
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: color,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Xóa bình luận",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
