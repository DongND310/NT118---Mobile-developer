import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<String> getUserID() async {
  //   String id = "";
  //   final querySnapshot = await _firestore
  //       .collection('users')
  //       .where("Email", isEqualTo: _auth.currentUser!.email)
  //       .get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     id = querySnapshot.docs[0].id;
  //   } else {
  //     print('Document does not exist');
  //   }
  //   return id;
  // }
  // Send message
  Future<void> sendMessage(String receiverId, String receiverName, String message) async {
    final Timestamp timestamp = Timestamp.now();
    // Create message
    Message newMessage = Message(
      senderId: _auth.currentUser!.uid,
      receiverId: receiverId,
      receiverName: receiverName,
      message: message,
      timestamp: timestamp,
    );
    // Chatroom ID
    List<String> ids = [_auth.currentUser!.uid, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Check if chatroom exists, if not, create one
    DocumentSnapshot chatRoomSnapshot = await _firestore.collection("chatrooms").doc(chatRoomId).get();
    if (!chatRoomSnapshot.exists) {
      // Create a new chatroom document
      await _firestore.collection("chatrooms").doc(chatRoomId).set({
        "chatroomId": chatRoomId, // Add chatroomId field
        // You can add more fields here if needed
      });
    }

    // Add message to database
    await _firestore.collection("chatrooms").doc(chatRoomId).collection("messages").add(newMessage.toMap());
  }


  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, String anotherUserID) {
    List<String> ids = [userID, anotherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
  Stream<QuerySnapshot> getChatRooms(){
    return _firestore.collection("chatrooms").where("chatRoomId", arrayContains: _auth.currentUser!.uid).snapshots();
  }

}
