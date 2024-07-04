import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SuggestDetail extends StatelessWidget {
   SuggestDetail( {super.key});
  final user = FirebaseAuth.instance.currentUser;
  final List<String> listVidIds= [];
   // getFollowersCount() async {
   //   QuerySnapshot snapshot = await followersRef
   //       .doc(widget.visitedUserID)
   //       .collection("userFollowers")
   //       .get();
   //   if (mounted) {
   //     setState(() {
   //       _followersCount = snapshot.docs.length;
   //     });
   //   }
   // }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container();
        }
    );
  }
}