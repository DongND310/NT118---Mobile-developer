import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/components/comment_page.dart';
import 'package:mobile_project/components/custom_delete.dart';
import 'package:mobile_project/components/delete_video.dart';
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

    getsumReplyCount();
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

  void toggleLike() async {
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid, "like"];
      String reactorId = ids.join('_');
      if (currentUser.uid != widget.video.postedById) {
        await firestore
            .collection('users')
            .doc(widget.video.postedById)
            .collection('notifications')
            .doc(widget.video.videoId)
            .set({
          'videoId': widget.video.videoId,
        });

        await firestore
            .collection('users')
            .doc(widget.video.postedById)
            .collection('notifications')
            .doc(widget.video.videoId)
            .collection('reactors')
            .doc(reactorId)
            .set({
          'type': 'video_like',
          'senderId': currentUser.uid,
          'videoId': widget.video.videoId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      videoRef.update({
        'likesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  void toggleSave() async {
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
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid, "save"];
      String reactorId = ids.join('_');
      if (currentUser.uid != widget.video.postedById) {
        await firestore
            .collection('users')
            .doc(widget.video.postedById)
            .collection('notifications')
            .doc(widget.video.videoId)
            .set({
          'videoId': widget.video.videoId,
        });

        await firestore
            .collection('users')
            .doc(widget.video.postedById)
            .collection('notifications')
            .doc(widget.video.videoId)
            .collection('reactors')
            .doc(reactorId)
            .set({
          'type': 'video_save',
          'senderId': currentUser.uid,
          'videoId': widget.video.videoId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      videoRef.update({
        'savesList': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  void getsumReplyCount() async {
    int totalReplies = 0;

    QuerySnapshot repliesSnapshot = await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.video.videoId)
        .collection('replies')
        .get();
    totalReplies += repliesSnapshot.docs.length;

    for (QueryDocumentSnapshot replyDoc in repliesSnapshot.docs) {
      QuerySnapshot subrepliesSnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.video.videoId)
          .collection('replies')
          .doc(replyDoc.id)
          .collection('subreplies')
          .get();
      totalReplies += subrepliesSnapshot.docs.length;
    }

    setState(() {
      replyCount = totalReplies;
    });
  }

  final user = FirebaseAuth.instance.currentUser!;

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
          widget.video.postedById == user.uid
              ? IconButton(
                  onPressed: () {
                    showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            maxChildSize: 0.15,
                            initialChildSize: 0.15,
                            minChildSize: 0.1,
                            builder: (context, scrollController) {
                              return DeleteVideo(
                                id: widget.video.videoId,
                              );
                            },
                          );
                        });
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/post_option.svg',
                    width: 6,
                    height: 6,
                    color: Colors.white,
                  ),
                )
              : SizedBox(),
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
                  return CommentPage(video: widget.video);
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
