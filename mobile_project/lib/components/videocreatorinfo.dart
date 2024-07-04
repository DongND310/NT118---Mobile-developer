import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class VideoCreatorInfo extends StatefulWidget {
  VideoCreatorInfo({Key? key, required this.video}) : super(key: key);

  final VideoModel video;

  @override
  _VideoCreatorInfoState createState() => _VideoCreatorInfoState();
}

class _VideoCreatorInfoState extends State<VideoCreatorInfo> {
  String? _avt;
  String? _name;
  bool _isLoading = true; // Trạng thái tải dữ liệu
  bool _isExpanded = false; // Trạng thái mở rộng caption

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  final user = FirebaseAuth.instance.currentUser!;

  void getUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.video.postedById)
        .get();

    setState(() {
      _name = userDoc.get('Name');
      _avt = userDoc.get('Avt');
      _isLoading = false; // Dữ liệu đã tải xong
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      visitedUserID: widget.video.postedById,
                      currentUserId: user.uid,
                      isBack: true,
                    ),
                  ));
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 15),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: _avt != null
                        ? NetworkImage(_avt!)
                        : const AssetImage('assets/images/default_avt.png')
                            as ImageProvider,
                  ),
                ),
                Text(
                  _name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.caption,
                      maxLines: _isExpanded ? 20 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
