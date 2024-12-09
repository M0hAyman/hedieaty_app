import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // Add user to Firestore
  Future<void> addUser(Map<String, dynamic> userData) async {
    await userCollection.add(userData);
  }

  // Fetch all users
  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    QuerySnapshot snapshot = await userCollection.get();
    return snapshot.docs;
  }

  // Fetch a user by email
  Future<QueryDocumentSnapshot?> getUserByEmail(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
  }

  // Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await userCollection.doc(userId).update(data);
  }

  // Delete a user
  Future<void> deleteUser(String userId) async {
    await userCollection.doc(userId).delete();
  }
}
