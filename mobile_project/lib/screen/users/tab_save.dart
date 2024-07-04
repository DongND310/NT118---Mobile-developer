import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'dart:io';
import '../../components/video_detail.dart';
import '../../models/video_model.dart';

class SaveTab extends StatelessWidget {
  final String userId;
  const SaveTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: videoRef.where('savesList', arrayContains: userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Container();
          } else if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Bạn chưa lưu video nào',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15
                ),
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
                        builder: (context) =>
                            VideoDetailScreen(
                                video: video),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: Container(
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
                  )
              );
            },
          );
        }
    );
  }
}
