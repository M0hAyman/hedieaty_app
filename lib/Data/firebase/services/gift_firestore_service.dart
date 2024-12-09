import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Models/gift_model.dart';


class GiftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'gifts';

  // Add a new gift
  Future<void> addGift(Gift gift) async {
    await _firestore.collection(_collection).add(gift.toFirestore());
  }

  // Get gifts for a specific event
  Future<List<Gift>> getGiftsByEvent(String eventId) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('eventId', isEqualTo: eventId)
        .get();

    return querySnapshot.docs.map((doc) => Gift.fromFirestore(doc)).toList();
  }

  // Update a gift's status
  Future<void> updateGiftStatus(String giftId, String newStatus) async {
    await _firestore.collection(_collection).doc(giftId).update({
      'status': newStatus,
    });
  }

  // Update gift's pledgedBy field
  Future<void> pledgeGift(String giftId, String pledgedByUserId) async {
    await _firestore.collection(_collection).doc(giftId).update({
      'status': 'pledged',
      'pledgedBy': pledgedByUserId,
    });
  }

  // Delete a gift
  Future<void> deleteGift(String giftId) async {
    await _firestore.collection(_collection).doc(giftId).delete();
  }
}
