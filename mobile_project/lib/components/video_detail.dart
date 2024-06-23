import 'package:expandable_text/expandable_text.dart';
import 'package:mobile_project/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/models/video.dart';
import '../screen/users/profile_page.dart';

class VideoDetail extends StatefulWidget {
  const VideoDetail({super.key, required this.video, required this.user});
  final Video video;
  //final UserModel user;
  final User user;

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          dense: true,
          minLeadingWidth: 0,
          horizontalTitleGap: 10,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          currentUserId: user.uid,
                          visitedUserID: "6vBu7yGZuAXssP2ogJYVbdTtczj2")));
            },
            child: Text(
              "${widget.video.postedBy.username} - Follow",
              style: const TextStyle(
                  color: Color(0xffF1FCFD),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          leading: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(widget.user.profileImageUrl!)
              // backgroundImage: user.avt != null?NetworkImage(user.avt!)
              //     : Image.asset(
              //   'assets/images/default_avt.png').image,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: ExpandableText(
            widget.video.caption,
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w100),
            expandText: 'more',
            collapseText: 'less',
            expandOnTextTap: true,
            collapseOnTextTap: true,
            maxLines: 2,
            linkColor: Colors.grey,
          ),
        ),
        ListTile(
          dense: true,
          minLeadingWidth: 0,
          horizontalTitleGap: 5,
          title: Text(
            widget.video.audioName,
            style: const TextStyle(
                color: Color(0xffF1FCFD),
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
          leading: const Icon(
            CupertinoIcons.music_note_2,
            size: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
