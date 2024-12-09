import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Models/friend_model.dart';


class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'friends';

  // Add a new friend request
  Future<void> addFriend(Friend friend) async {
    await _firestore.collection(_collection).add(friend.toFirestore());
  }

  // Get friends for a specific user
  Future<List<Friend>> getFriends(String userId) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => Friend.fromFirestore(doc)).toList();
  }

  // Update friendship status
  Future<void> updateFriendStatus(String friendId, String status) async {
    await _firestore.collection(_collection).doc(friendId).update({'status': status});
  }

  // Delete a friend
  Future<void> deleteFriend(String friendId) async {
    await _firestore.collection(_collection).doc(friendId).delete();
  }
}
