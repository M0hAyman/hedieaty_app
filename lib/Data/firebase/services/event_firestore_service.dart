import 'package:cloud_firestore/cloud_firestore.dart';

class EventFirestoreService {
  final CollectionReference eventCollection =
  FirebaseFirestore.instance.collection('events');

  // Add event to Firestore
  Future<void> addEvent(Map<String, dynamic> eventData) async {
    await eventCollection.add(eventData);
  }

  // Fetch events for a specific user
  Future<List<QueryDocumentSnapshot>> getEventsByUser(String userId) async {
    QuerySnapshot snapshot =
    await eventCollection.where('userId', isEqualTo: userId).get();
    return snapshot.docs;
  }

  // Update event data
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await eventCollection.doc(eventId).update(data);
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    await eventCollection.doc(eventId).delete();
  }
}
