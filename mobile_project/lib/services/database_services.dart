import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_project/constants.dart';

class DatabaseServices {
  Stream<QuerySnapshot> listFollower(String userId) {
    return followersRef.doc(userId).collection("userFollowers").snapshots();
  }

  Stream<QuerySnapshot> listFollowing(String userId) {
    return followingsRef.doc(userId).collection("userFollowings").snapshots();
  }

   Future<QuerySnapshot> searchUsers(String name) async {
   return usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();
  }
}
