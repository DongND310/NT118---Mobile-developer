import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/screen/posts_videos/video_player_item.dart';
import '../screen/users/profile_page.dart';

class VideoDetail extends StatelessWidget {
  VideoDetail(
      {super.key, required this.video, required this.user, required videoUrl});
  final VideoModel video;
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VideoPlayerItem(
          videoUrl: video.videoUrl,
          index: 0,
        ),
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
                          currentUserId: "CP5ovzUbQTYsCsY8PN8tyf4mxjg1",
                          visitedUserID: "G0BT9oat2MW8ltF56E0nm3An05w2")));
            },
            child: const Text(
              "data.postByName - Follow",
              style: TextStyle(
                  color: Color(0xffF1FCFD),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          leading: CircleAvatar(
            radius: 14,
            //backgroundImage: NetworkImage(user.profileImageUrl!)
            backgroundImage: user.avt != null
                ? NetworkImage(user.avt!)
                : Image.asset('assets/images/default_avt.png').image,
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
        // ListTile(
        //   dense: true,
        //   minLeadingWidth: 0,
        //   horizontalTitleGap: 5,
        //   title: Text(
        //     video.songName,
        //     style: const TextStyle(
        //         color: Color(0xffF1FCFD),
        //         fontWeight: FontWeight.w500,
        //         fontSize: 12),
        //   ),
        //   leading: const Icon(
        //     CupertinoIcons.music_note_2,
        //     size: 15,
        //     color: Colors.white,
        //   ),
        // ),
        const SizedBox(height: 10),
      ],
    );
  }
}
