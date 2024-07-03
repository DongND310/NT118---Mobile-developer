import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class FollowNoti extends StatefulWidget {
  final String senderId;
  final Timestamp timestamp;

  FollowNoti({
    required this.senderId,
    required this.timestamp,
  });

  @override
  State<FollowNoti> createState() => _FollowNotiState();
}

class _FollowNotiState extends State<FollowNoti> {
  String? _name;
  String? _avt;
  String? _Uname;
  String? _Uavt;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentUserData();
    checkFollowing();
  }

  void getUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.senderId)
        .get();

    setState(() {
      _name = userDoc.get('Name');
      _avt = userDoc.get('Avt');
    });
  }

  void getCurrentUserData() async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      _Uname = userDoc.get('Name');
      _Uavt = userDoc.get('Avt');
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _isFollowing = false;

  checkFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.senderId)
        .collection("userFollowers")
        .doc(userId)
        .get();
    setState(() {
      _isFollowing = doc.exists;
    });
  }

  Widget buildButton({required String text, required VoidCallback function}) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
        side: MaterialStateProperty.all(
            const BorderSide(width: 1, color: Colors.blue)),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(150, 55),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            _isFollowing ? Colors.white : Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(
            _isFollowing ? Colors.blue : Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    if (_isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else {
      return buildButton(text: "Follow", function: handleFollowUser);
    }
  }

  handleUnfollowUser() async {
    setState(() {
      _isFollowing = false;
      // _followersCount -= 1;
    });

    followersRef
        .doc(widget.senderId)
        .collection('userFollowers')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingsRef
        .doc(userId)
        .collection('userFollowings')
        .doc(widget.senderId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    userRef.update({
      'followingsList': FieldValue.arrayRemove([widget.senderId])
    });
  }

  handleFollowUser() async {
    followersRef
        .doc(widget.senderId)
        .collection('userFollowers')
        .doc(userId)
        .set({});

    followingsRef
        .doc(userId)
        .collection('userFollowings')
        .doc(widget.senderId)
        .set({});
    setState(() {
      _isFollowing = true;
      // _followersCount += 1;
    });

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    userRef.update({
      'followingsList': FieldValue.arrayUnion([widget.senderId])
    });

    //noti
    if (widget.senderId != currentUser.uid) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> ids = [currentUser.uid ?? "", "follow"];
      String reactorId = ids.join('_');
      await firestore
          .collection('users')
          .doc(widget.senderId)
          .collection('notifications')
          .doc(reactorId)
          .set({});

      await firestore
          .collection('users')
          .doc(widget.senderId)
          .collection('notifications')
          .doc(reactorId)
          .collection('reactors')
          .doc(currentUser.uid)
          .set({
        'type': 'follow',
        'senderId': currentUser.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

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
    return ListTile(
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: _avt != null
                  ? NetworkImage(_avt!)
                  : const AssetImage('assets/images/default_avt.png')
                      as ImageProvider,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_name ',
                            style: const TextStyle(
                              height: 1,
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: "đã theo dõi bạn.",
                            style: TextStyle(
                              height: 1.4,
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: "  ${formatTimestamp(widget.timestamp)}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )),
                buildProfileButton()
              ],
            ))
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                visitedUserID: widget.senderId,
                currentUserId: userId ?? "",
                isBack: true,
              ),
            ));
      },
    );
  }
}
