import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/comment_page.dart';
import 'package:mobile_project/models/video_model.dart'; // Thay đổi này

class HomeSideBar extends StatefulWidget {
  HomeSideBar(
      {super.key,
      required this.video,
      required this.likesList,
      required this.repliesList,
      required this.savesList});

  final VideoModel video;
  final List<String> likesList;
  final List<String> repliesList;
  final List<String> savesList;

  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late bool isLiked;
  late bool isSaved;
  int likeCount = 0;
  int replyCount = 0;
  int saveCount = 0;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationController.repeat();
    super.initState();

    isLiked = false;
    isSaved = false;
    FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<dynamic> likesList = data?['likesList'];
          likeCount = likesList.length;
          isLiked = likesList.contains(currentUser.uid);

          List<dynamic> savesList = data?['savesList'];
          saveCount = savesList.length;
          isSaved = savesList.contains(currentUser.uid);

          List<dynamic> repliesList = data?['repliesList'];
          replyCount = repliesList.length;
        });
      }
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId);

    Stream<DocumentSnapshot> videoStream = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .snapshots();

    if (isLiked) {
      videoRef.update({
        'likesList': FieldValue.arrayUnion([currentUser.uid])
      });
    } else {
      videoRef.update({
        'likesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });

    DocumentReference videoRef = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId);

    Stream<DocumentSnapshot> videoStream = FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .snapshots();

    if (isSaved) {
      videoRef.update({
        'savesList': FieldValue.arrayUnion([currentUser.uid])
      });
    } else {
      videoRef.update({
        'savesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 12, color: const Color(0xffF1FCFD));
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _sideBarItem('heart', "${likeCount}", style, toggleLike, isLiked),
          _sideBarComment('comment', '${replyCount}', style),
          _sideBarItem('bookmark', '${saveCount}', style, toggleSave, isSaved),
        ],
      ),
    );
  }

  _sideBarItem(String iconName, String label, TextStyle style, Function() onTap,
      bool isReact) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/${isReact ? '${iconName}_filled' : iconName}.svg',
            width: 25,
            height: 25,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: style,
          ),
        ],
      ),
    );
  }

  _sideBarComment(String iconName, String label, TextStyle style) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return DraggableScrollableSheet(
                maxChildSize: 0.8,
                initialChildSize: 0.8,
                minChildSize: 0.3,
                builder: (context, scrollController) {
                  return const CommentPage();
                },
              );
            });
      },
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/$iconName.svg',
            width: 25,
            height: 25,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: style,
          ),
        ],
      ),
    );
  }
}
