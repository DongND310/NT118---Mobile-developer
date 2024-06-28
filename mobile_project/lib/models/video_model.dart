// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_project/models/video.dart';

class VideoModel {
  String videoId;
  String postedById;
  String postByName;
  String postByAvt;
  String songName;
  String caption;
  String videoUrl;
  String thumbnail;
  List likes;
  int comments;
  int bookmarks;

  VideoModel({
    required this.videoId,
    required this.postedById,
    required this.postByName,
    required this.postByAvt,
    required this.songName,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.likes,
    required this.comments,
    required this.bookmarks,
  });

  Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "postedById": postedById,
        "postByName": postByName,
        "postByAvt": postByAvt,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "likes": likes,
        "comments": comments,
        "bookmarks": bookmarks,
      };
  static VideoModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return VideoModel(
      videoId: snapshot['videoId'],
      postedById: snapshot['postedById'],
      postByName: snapshot['postByName'],
      postByAvt: snapshot['postByAvt'],
      songName: snapshot['songName'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      thumbnail: snapshot['thumbnail'],
      likes: snapshot['likes'],
      comments: snapshot['comments'],
      bookmarks: snapshot['bookmarks'],
    );
  }
}
