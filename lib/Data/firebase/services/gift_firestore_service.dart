import 'package:cloud_firestore/cloud_firestore.dart';

class GiftFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a gift
  Future<DocumentReference> addGift(String userId, String eventId, Map<String, dynamic> giftData) async {
    try {
      if (userId.isEmpty || eventId.isEmpty) {
        throw Exception('User ID or Event ID is missing');
      }
      return await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .add(giftData);
    } catch (e) {
      print("Error adding gift: $e");
      rethrow;
    }
  }


  // Update a gift
  Future<void> updateGift(String userId, String eventId, String giftId, Map<String, dynamic> giftData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .doc(giftId)
          .update(giftData);
    } catch (e) {
      print("Error updating gift: $e");
      rethrow;
    }
  }


  // Fetch all gifts for a specific event
  Future<List<QueryDocumentSnapshot>> getGiftsByEvent(String userId, String? eventId) async {
    if(eventId == null) {
      print('Firebase Event ID is null!');
      return [];
    }
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .get();

    return querySnapshot.docs;
  }

  // Delete a gift
  Future<void> deleteGift(String userId, String? eventId, String giftId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .delete();
  }

  // Update pledge status
  Future<void> pledgeGift(
      String currUserId,String userId, String eventId, String giftId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .collection('gifts')
          .doc(giftId)
          .update({
        'IS_PLEDGED': 1,
        'PLEDGED_BY': currUserId,
      });
    } catch (e) {
      print("Error updating gift status: $e");
      rethrow;
    }
  }

  //replace pledgeGift and unpledgeGift with the above method for better flexibility.

  // Future<void> unpledgeGift(String userId, String eventId, String giftId) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('events')
  //       .doc(eventId)
  //       .collection('gifts')
  //       .doc(giftId)
  //       .update({'status': 'available', 'pledgedBy': null});
  // }
}
