import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class DeleteComment extends StatefulWidget {
  DeleteComment(
      {super.key, required this.id, required this.userId, required this.cmtId});
  final String id;
  final String cmtId;
  final String userId;
  @override
  State<DeleteComment> createState() => _DeleteCommentState();
}

class _DeleteCommentState extends State<DeleteComment> {
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
                      final commentDocs = await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.id)
                          .collection('replies')
                          .doc(widget.cmtId)
                          .collection('subreplies')
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.id)
                            .collection('replies')
                            .doc(widget.cmtId)
                            .delete();
                      }

                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.id)
                          .collection('replies')
                          .doc(widget.cmtId)
                          .delete()
                          .then((value) => print("đã xóa comment"))
                          .catchError(
                              (error) => print("lỗi xóa comment: $error"));
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
