import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_project/constants.dart';
import 'dart:io';
import '../../../components/video_detail.dart';
import '../../../models/video_model.dart';

class SuggestDetail extends StatefulWidget {
  const SuggestDetail({super.key});

  @override
  State<StatefulWidget> createState() => _SuggestState();
}
class _SuggestState extends State<SuggestDetail> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> top5VideoIds =[];

   getTop5Video() async {
     QuerySnapshot snapshot = await videoRef.get();
     if(snapshot.docs.isNotEmpty)
       {
         List<Map<String, dynamic>> videoLikes = snapshot.docs.map((doc) {
           var data = doc.data() as Map<String, dynamic>;
           List<String> likes = List<String>.from(data['likesList'] ?? []);
           return {
             'id': doc.id,
             'likeCount': likes.length,
           };
         }).toList();
         videoLikes.sort((a, b) => b['likeCount'].compareTo(a['likeCount']));
         setState(() {
           top5VideoIds = videoLikes.take(5).map((video) => video['id'] as String).toList();
         });
       }
   }
   @override
  void initState() {
    super.initState();
    getTop5Video();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: top5VideoIds.length,
        itemBuilder: (BuildContext context, int index) {
          return StreamBuilder(stream: videoRef.doc(top5VideoIds[index]).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData ||
                    snapshot.data == null) {
                  return const Text('No data available');
                }
                VideoModel video =
                VideoModel.fromDocument(
                    snapshot.data!);
                return Padding(padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoDetailScreen(
                                  video: video),
                        ),
                      );
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width ,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(style: BorderStyle.none, width: 2),
                            ),
                            child: Image.file(File(''),
                              fit: BoxFit.fill,
                              ),
                          ),
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                          child: Text(video.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.blue)),
                          )
                        ],
                      ),
                    )),
                );
              },
          );
        }
    );
  }
  // Future<String?> _generateThumbnail(String videoUrl) async {
  //   try {
  //     final response = await http.get(Uri.parse(videoUrl));
  //
  //     if (response.statusCode == 200) {
  //       final tempDir = await getTemporaryDirectory();
  //       final videoFile = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4');
  //       await videoFile.writeAsBytes(response.bodyBytes);
  //
  //       final thumbnailPath = await VideoThumbnail.thumbnailFile(
  //         video: videoFile.path,
  //         thumbnailPath: tempDir.path,
  //         imageFormat: ImageFormat.PNG,
  //         maxHeight: 200,
  //         quality: 75,
  //       );
  //
  //       await videoFile.delete();
  //
  //       return thumbnailPath;
  //     } else {
  //       print('Không thể tải video từ URL: $videoUrl');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Lỗi khi tạo thumbnail: $e');
  //     return null;
  //   }
  // }

}