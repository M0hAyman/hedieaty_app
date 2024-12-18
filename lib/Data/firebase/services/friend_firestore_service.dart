import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Models/friend_model.dart';

class FriendFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new friend (pending status by default)
  Future<void> addFriend({
    required String userId,
    required String friendId,
  }) async {
    try {
      final newFriend = Friend(
        id: '', // Firestore will generate this
        userId: userId,
        friendId: friendId,
        status: 'pending', // Default to pending
        createdAt: Timestamp.now(),
      );

      await _firestore.collection('friends').add(newFriend.toFirestore());
    } catch (e) {
      throw Exception('Error adding friend: $e');
    }
  }

  // Get all friends for the current user
  Future<List<Friend>> getFriends(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('friends')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      return querySnapshot.docs
          .map((doc) => Friend.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching friends: $e');
    }
  }

  // Update friend request status (accept/reject/block)
  Future<void> updateFriendStatus({
    required String friendId,
    required String status, // accepted/rejected/blocked
  }) async {
    try {
      final friendDoc = _firestore.collection('friends').doc(friendId);
      await friendDoc.update({'status': status});
    } catch (e) {
      throw Exception('Error updating friend status: $e');
    }
  }

  // Fetch a user's details by phone number
  Future<Map<String, String>?> getFriendByPhoneNumber(String phoneNumber) async {
    try {
      // Query Firestore for the user with the specified phone number
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No friend found with phone number $phoneNumber');
        return null; // No matching friend found
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      print('Found friend: ${data['name']} (UID: ${doc.id})');
      return {
        'uid': doc.id,
        'name': data['name'] ?? 'Unknown',
      };
    } catch (e) {
      print('Error fetching friend by phone number: $e');
      throw Exception('Error fetching friend by phone number: $e');
    }
  }


}
