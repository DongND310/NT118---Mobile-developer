import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? postId;
  final String creatorId;
  final String creatorName;
  final String creatorImg;
  final String content;
  final Timestamp timestamp;

  Post({
    this.postId,
    required this.creatorId,
    required this.creatorName,
    required this.creatorImg,
    required this.content,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorImg': creatorImg,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
