// import 'dart:ffi';

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_project/models/video.dart';

class VideoModel {
  String videoId;
  String postedById;
  String caption;
  String videoUrl;
  final Timestamp timestamp;
  DocumentReference? ref;

  // String postByName;
  // String postByAvt;
  // String songName;
  // String thumbnail;
  // List likes;
  // int comments;
  // int bookmarks;

  VideoModel({
    required this.videoId,
    required this.postedById,
    required this.caption,
    required this.videoUrl,
    required this.timestamp,
    this.ref,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoId: json['videoId'],
      postedById: json['postedById'],
      caption: json['content'],
      timestamp: json['timestamp'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "postedById": postedById,
        "caption": caption,
        "videoUrl": videoUrl,
      };
  static VideoModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return VideoModel(
        videoId: snapshot['videoId'],
        postedById: snapshot['postedById'],
        caption: snapshot['caption'],
        videoUrl: snapshot['videoUrl'],
        timestamp: snapshot['timestamp']
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'postedById': postedById,
      'caption': caption,
      'videoUrl': videoUrl,
      'timestamp': timestamp,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map,
      {DocumentReference? ref}) {
    return VideoModel(
      videoId: map['videoId'] ?? '',
      postedById: map['postedById'] ?? '',
      caption: map['caption'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      timestamp: map['timestamp'],
      ref: ref,
    );
  }
}
