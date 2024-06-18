import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String creatorId;
  final String content;
  // List<String> likesList;
  final Timestamp timestamp;
  DocumentReference? ref;

  PostModel({
    required this.postId,
    required this.creatorId,
    required this.content,
    required this.timestamp,
    this.ref,
  });

  // Chuyển đổi từ Firestore document thành PostModel
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      creatorId: data['creatorId'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? 0,
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      postId: id,
      content: map['content'] ?? '',
      creatorId: map['userId'] ?? '',
      timestamp: map['timestamp'] ?? '',
      // Initialize other fields from map as needed
    );
  }

  // Chuyển đổi từ PostModel thành Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'creatorId': creatorId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
