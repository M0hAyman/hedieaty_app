import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Models/friend_model.dart';

class FriendFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend({
    required String fromUserId,
    required String phoneNumber,
  }) async {
    try {
      // Find the friend by phone number
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No user found with this phone number.');
      }

      final toUser = querySnapshot.docs.first;

      // Fetch the sender's user details
      final fromUser = await _firestore.collection('users').doc(fromUserId).get();

      if (!fromUser.exists) {
        throw Exception('Sender user not found.');
      }

      // Prepare friend data
      final friendData = {
        'fromId': fromUserId,
        'toId': toUser.id,
        'fromName': fromUser['name'],
        'toName': toUser['name'],
        'createdAt': Timestamp.now(),
      };

      // Add to both users' acceptedFriends subcollection
      final batch = _firestore.batch();

      // Add to the current user's accepted friends
      batch.set(
        _firestore
            .collection('users')
            .doc(fromUserId)
            .collection('acceptedFriends')
            .doc(toUser.id),
        friendData,
      );

      // Add to the friend's accepted friends
      batch.set(
        _firestore
            .collection('users')
            .doc(toUser.id)
            .collection('acceptedFriends')
            .doc(fromUserId),
        friendData,
      );

      // Commit the batch
      await batch.commit();
    } catch (e) {
      throw Exception('Error adding friend: $e');
    }
  }


  // Fetch all accepted friends for the current user
  Future<List<Friend>> getAcceptedFriends(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('acceptedFriends')
          .get();

      return querySnapshot.docs.map((doc) {
        return Friend.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching accepted friends: $e');
    }
  }

 




}
