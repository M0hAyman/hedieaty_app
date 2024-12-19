import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Models/friend_model.dart';


class FriendFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a friend request by phone number
  Future<void> sendFriendRequest({
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

      // Add a friend request to the recipient's `friendRequests`
      final requestData = {
        'fromId': fromUserId,
        'toId': toUser.id,
        'name': toUser['name'], // Include the friend's name
        'status': 'pending',
        'createdAt': Timestamp.now(),
      };

      // Add the friend request to the recipient's `friendRequests`
      await _firestore
          .collection('users')
          .doc(toUser.id)
          .collection('friendRequests')
          .add(requestData);

      // Reflect the same request on the sender's side as "pending"
      await _firestore
          .collection('users')
          .doc(fromUserId)
          .collection('friendRequests')
          .add({
        ...requestData,
        'fromId': fromUserId, // Ensure clarity in the sender's perspective
        'toId': toUser.id,
      });
    } catch (e) {
      throw Exception('Error sending friend request: $e');
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

      return querySnapshot.docs
          .map((doc) => Friend.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching accepted friends: $e');
    }
  }

  Future<void> handleFriendRequest({
    required String requestId,
    required String currentUserId,
    required String friendId,
    required bool accept,
  }) async {
    try {
      // Access the current user's friend request
      final requestRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequests')
          .doc(requestId);

      // Update the status in the current user's request
      if (accept) {
        // Update status to accepted in the current user's friendRequests
        await requestRef.update({'status': 'accepted'});

        // Add to both users' acceptedFriends sub-collections
        final friendDoc = await _firestore.collection('users').doc(friendId).get();

        await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('acceptedFriends')
            .doc(friendId)
            .set({
          'id': friendId,
          'name': friendDoc['name'],
          'email': friendDoc['email'],
          'phone': friendDoc['phone'],
        });

        await _firestore
            .collection('users')
            .doc(friendId)
            .collection('acceptedFriends')
            .doc(currentUserId)
            .set({
          'id': currentUserId,
          'name': friendDoc['name'],
          'email': friendDoc['email'],
          'phone': friendDoc['phone'],
        });
      } else {
        // Reject: delete the request in both users' friendRequests
        await requestRef.delete();
      }
    } catch (e) {
      throw Exception('Error handling friend request: $e');
    }
  }

  // Fetch all pending requests sent by the user
  Future<List<Friend>> getPendingSentRequests(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friendRequests')
          .where('status', isEqualTo: 'pending')
          .where('fromId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => Friend.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching pending sent requests: $e');
    }
  }

// Fetch all pending requests received by the user
  Future<List<Friend>> getPendingReceivedRequests(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friendRequests')
          .where('status', isEqualTo: 'pending')
          .where('toId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => Friend.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching pending received requests: $e');
    }
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(Friend request) async {
    try {
      final batch = _firestore.batch();

      // Update the friend request status to 'accepted'
      final currentUserRequestRef = _firestore
          .collection('users')
          .doc(request.userId)
          .collection('friendRequests')
          .doc(request.id);
      batch.update(currentUserRequestRef, {'status': 'accepted'});

      // Create or update the friend relationship in the recipient's collection
      final friendRequestRef = _firestore
          .collection('users')
          .doc(request.friendId)
          .collection('friendRequests')
          .doc(request.id);
      batch.update(friendRequestRef, {'status': 'accepted'});

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error accepting friend request: $e');
      throw Exception('Failed to accept friend request');
    }
  }

  // Reject a friend request
  Future<void> rejectFriendRequest(Friend request) async {
    try {
      final batch = _firestore.batch();

      // Update the friend request status to 'rejected'
      final currentUserRequestRef = _firestore
          .collection('users')
          .doc(request.userId)
          .collection('friendRequests')
          .doc(request.id);
      batch.update(currentUserRequestRef, {'status': 'rejected'});

      // Update the status in the friend's collection
      final friendRequestRef = _firestore
          .collection('users')
          .doc(request.friendId)
          .collection('friendRequests')
          .doc(request.id);
      batch.update(friendRequestRef, {'status': 'rejected'});

      // Commit the batch operation
      await batch.commit();
    } catch (e) {
      print('Error rejecting friend request: $e');
      throw Exception('Failed to reject friend request');
    }
  }


}
