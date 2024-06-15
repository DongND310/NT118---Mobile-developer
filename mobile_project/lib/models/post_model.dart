import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String creatorId;
  final String content;
  int? like;
  int? reply;
  final Timestamp timestamp;

  PostModel({
    required this.postId,
    required this.creatorId,
    required this.like,
    required this.reply,
    required this.content,
    required this.timestamp,
  });

  // Chuyển đổi từ Firestore document thành PostModel
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      creatorId: data['creatorId'] ?? '',
      content: data['content'] ?? '',
      like: 0,
      reply: 0,
      timestamp: data['timestamp'] ?? 0,
    );
  }

  // Chuyển đổi từ PostModel thành Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'creatorId': creatorId,
      'content': content,
      'like': like,
      'reply': reply,
      'timestamp': timestamp,
    };
  }
}
