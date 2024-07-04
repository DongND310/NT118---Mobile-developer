import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class DeleteVideo extends StatefulWidget {
  const DeleteVideo({super.key, required this.id});
  final String id;
  @override
  State<DeleteVideo> createState() => _DeleteVideoState();
}

class _DeleteVideoState extends State<DeleteVideo> {
  void deleteVideo() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Cảnh báo!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Bạn có chắc chắn muốn xóa video này không?',
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Xóa',
                        style: TextStyle(color: Colors.red, fontSize: 17)),
                    onPressed: () async {
                      // Navigator.pop(context);
                      final commentDocs = await FirebaseFirestore.instance
                          .collection('videos')
                          .doc(widget.id)
                          .collection('replies')
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection('videos')
                            .doc(widget.id)
                            .delete();
                      }

                      FirebaseFirestore.instance
                          .collection('videos')
                          .doc(widget.id)
                          .delete()
                          .then((value) => print("đã xóa video"))
                          .catchError(
                              (error) => print("lỗi xóa video: $error"));
                      Navigator.pop(context);
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              visitedUserID: user.uid,
                              currentUserId: user.uid,
                              isBack: false,
                            ),
                          ));
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
          onTap: deleteVideo,
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
                  "Xóa video",
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
