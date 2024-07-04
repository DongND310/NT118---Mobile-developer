import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
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
  List<String> top5VideoIds = [];

  @override
  void initState() {
    super.initState();
    getTop5Video();
  }

  Future<void> getTop5Video() async {
    QuerySnapshot snapshot = await videoRef.get();
    if (snapshot.docs.isNotEmpty) {
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
        top5VideoIds =
            videoLikes.take(5).map((video) => video['id'] as String).toList();
      });
    }
  }

  Future<Map<String, dynamic>> getUserDataById(String id) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return {
      'avt': userDoc.get('Avt'),
      'name': userDoc.get('Name'),
    };
  }

  Future<List<String>> getDataList(String videoId, String fieldName) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoId)
        .get();
    List<String> dataList = List<String>.from(doc.get(fieldName) ?? []);
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: top5VideoIds.length,
      itemBuilder: (BuildContext context, int index) {
        return StreamBuilder(
          stream: videoRef.doc(top5VideoIds[index]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No data available');
            }
            VideoModel video = VideoModel.fromDocument(snapshot.data!);

            return Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDetailScreen(video: video),
                    ),
                  );
                },
                child: FutureBuilder<String?>(
                  future: _generateThumbnail(video.videoUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    String? thumbnailPath = snapshot.data;
                    return FutureBuilder<Map<String, dynamic>>(
                      future: getUserDataById(video.postedById),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!userSnapshot.hasData ||
                            userSnapshot.data == null) {
                          return const Text('No user data available');
                        }

                        String? avt = userSnapshot.data!['avt'];
                        String? name = userSnapshot.data!['name'];

                        return FutureBuilder(
                          future: Future.wait([
                            getDataList(video.videoId, 'likesList'),
                            getDataList(video.videoId, 'repliesList'),
                            getDataList(video.videoId, 'savesList')
                          ]),
                          builder: (context,
                              AsyncSnapshot<List<List<String>>>
                                  countsSnapshot) {
                            if (countsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            int likeCount = 0;
                            int replyCount = 0;
                            int saveCount = 0;

                            if (countsSnapshot.hasData &&
                                countsSnapshot.data != null) {
                              likeCount = countsSnapshot.data?[0].length ?? 0;
                              replyCount = countsSnapshot.data?[1].length ?? 0;
                              saveCount = countsSnapshot.data?[2].length ?? 0;
                            }

                            return Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          style: BorderStyle.none, width: 2),
                                    ),
                                    child: thumbnailPath != null
                                        ? Image.file(
                                            File(thumbnailPath),
                                            fit: BoxFit.fill,
                                          )
                                        : Image.asset(
                                            'assets/images/video_bg.jpg',
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, bottom: 40),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: CircleAvatar(
                                            backgroundImage: avt != null
                                                ? NetworkImage(avt)
                                                : null,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$name ',
                                                style: const TextStyle(
                                                  height: 1,
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                video.caption,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  height: 1.4,
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/heart.svg',
                                                    width: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    ' $likeCount    ',
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/comment.svg',
                                                    width: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    ' $replyCount    ',
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/bookmark.svg',
                                                    width: 15,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    ' $saveCount    ',
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _generateThumbnail(String videoUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200,
        quality: 75,
      );
      return thumbnailPath;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }
}
