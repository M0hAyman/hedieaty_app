import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a specific collection
  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  // General function to add a document
  Future<void> addDocument(
      {required String collectionName, required Map<String, dynamic> data}) async {
    await _firestore.collection(collectionName).add(data);
  }

  // General function to update a document
  Future<void> updateDocument({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionName).doc(documentId).update(data);
  }

  // General function to delete a document
  Future<void> deleteDocument({
    required String collectionName,
    required String documentId,
  }) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }
}
