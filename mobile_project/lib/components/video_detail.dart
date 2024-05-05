import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/user.dart';
import 'package:mobile_project/models/video.dart';
import 'package:mobile_project/screen/account/account_page.dart';

class VideoDetail extends StatelessWidget {
  const VideoDetail({super.key, required this.video, required this.user});
  final Video video;
  final User user;

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
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AccountPage()));
            },
            child: Text(
              "${video.postedBy.username} - Follow",
              style: const TextStyle(
                  color: Color(0xffF1FCFD),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          leading: CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(user.profileImageUrl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: ExpandableText(
            video.caption,
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
            video.audioName,
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
