import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';

import '../../components/video_detail.dart';
import '../../models/video_model.dart';

class VideoTab extends StatelessWidget {
  final String userId;

  const VideoTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: videoRef.where('postedById', isEqualTo: userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có video nào được đăng',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
          );
        }
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: snapshot.data!.size,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 3 / 4),
          itemBuilder: (context, index) {
            VideoModel video =
                VideoModel.fromDocument(snapshot.data!.docs[index]);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoDetailScreen(video: video),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(0.5),
                child: FutureBuilder<String?>(
                  future: _generateThumbnail(video.videoUrl),
                  builder: (context, thumbnailSnapshot) {
                    if (thumbnailSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.blue));
                    }

                    String? thumbnailPath = thumbnailSnapshot.data;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(style: BorderStyle.none, width: 2),
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
