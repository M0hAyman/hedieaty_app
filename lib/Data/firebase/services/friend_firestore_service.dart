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

  // Handle a friend request (accept or reject)
  Future<void> handleFriendRequest({
    required String requestId,
    required String currentUserId,
    required String friendId,
    required bool accept,
  }) async {
    try {
      final requestRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequests')
          .doc(requestId);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists) {
        throw Exception('Friend request not found.');
      }

      final requestData = requestDoc.data();

      if (accept) {
        // Update status to accepted
        await requestRef.update({'status': 'accepted'});

        // Add to both users' acceptedFriends
        await _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('acceptedFriends')
            .doc(friendId)
            .set({
          'fromId': currentUserId,
          'toId': friendId,
          'fromName': requestData!['fromName'],
          'toName': requestData['toName'],
          'createdAt': Timestamp.now(),
        });

        await _firestore
            .collection('users')
            .doc(friendId)
            .collection('acceptedFriends')
            .doc(currentUserId)
            .set({
          'fromId': friendId,
          'toId': currentUserId,
          'fromName': requestData['toName'], // Reverse perspective
          'toName': requestData['fromName'], // Reverse perspective
          'createdAt': Timestamp.now(),
        });
      } else {
        // Reject request
        await requestRef.delete();
      }
    } catch (e) {
      throw Exception('Error handling friend request: $e');
    }
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(Friend request) async {
    try {

      final batch = _firestore.batch();

      print('Request ID: ${request.id}');
      print('From ID: ${request.fromId}');
      print('To ID: ${request.toId}');
      // Current user's request reference
      final currentUserRequestRef = _firestore
          .collection('users')
          .doc(request.fromId)
          .collection('friendRequests')
          .doc(request.id);

      // Friend's request reference
      final friendRequestRef = _firestore
          .collection('users')
          .doc(request.toId)
          .collection('friendRequests')
          .doc(request.id);

      final currentUserRequestDoc = await currentUserRequestRef.get();
      final friendRequestDoc = await friendRequestRef.get();

      if (!currentUserRequestDoc.exists || !friendRequestDoc.exists) {
        throw Exception('Friend request document not found.');
      }

      print('Current User Request Path: ${currentUserRequestRef.path}');
      print('Friend Request Path: ${friendRequestRef.path}');

      // Update status to accepted
      batch.update(currentUserRequestRef, {'status': 'accepted'});
      batch.update(friendRequestRef, {'status': 'accepted'});

      // Add to both users' accepted friends list
      batch.set(
        _firestore
            .collection('users')
            .doc(request.fromId)
            .collection('acceptedFriends')
            .doc(request.toId),
        {
          'fromId': request.fromId,
          'toId': request.toId,
          'fromName': request.fromName,
          'toName': request.toName,
          'createdAt': Timestamp.now(),
        },
      );

      batch.set(
        _firestore
            .collection('users')
            .doc(request.toId)
            .collection('acceptedFriends')
            .doc(request.fromId),
        {
          'fromId': request.toId,
          'toId': request.fromId,
          'fromName': request.toName,
          'toName': request.fromName,
          'createdAt': Timestamp.now(),
        },
      );


      // Commit the batch
      try {
        await batch.commit();
      } catch (e) {
        throw Exception('Failed to commit batch: $e');
      }

    } catch (e, stackTrace) {
      print('Failed to accept friend request: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Failed to accept friend request: $e');
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

      return querySnapshot.docs.map((doc) => Friend.fromFirestore(doc)).toList();
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

      return querySnapshot.docs.map((doc) => Friend.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching pending received requests: $e');
    }
  }

  // Reject a friend request
  Future<void> rejectFriendRequest(Friend request) async {
    try {
      await _firestore
          .collection('users')
          .doc(request.toId)
          .collection('friendRequests')
          .doc(request.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to reject friend request: $e');
    }
  }
}
