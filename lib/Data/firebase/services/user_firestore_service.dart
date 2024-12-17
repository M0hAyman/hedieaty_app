import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Models/user_model.dart';

class UserFirestoreService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // Add user to Firestore
  Future<void> addUser(UserModel user) async {
    await userCollection.doc(user.id).set(user.toFirestore());
  }

  // Fetch all users
  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot snapshot = await userCollection.get();
    return snapshot.docs.map((doc) {
      return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Fetch a user by email
  Future<UserModel?> getUserByEmail(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = snapshot.docs.first;
      return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    await userCollection.doc(user.id).update(user.toFirestore());
  }

  // Delete a user
  Future<void> deleteUser(String userId) async {
    await userCollection.doc(userId).delete();
  }
}
