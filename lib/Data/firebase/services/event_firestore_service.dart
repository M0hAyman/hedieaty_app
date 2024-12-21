import 'package:cloud_firestore/cloud_firestore.dart';

class EventFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add event to Firestore
  Future<DocumentReference> addEvent(String userId, Map<String, dynamic> eventData) async {
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .add(eventData);
  }

  // Fetch events for a specific user
  Future<List<QueryDocumentSnapshot>> getEventsByUser(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .get();
    return snapshot.docs;
  }

  // Update event
  Future<void> updateEvent(String userId, String eventId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .update(data);
  }

  // Delete event
  Future<void> deleteEvent(String userId, String eventId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .delete();
  }
}
