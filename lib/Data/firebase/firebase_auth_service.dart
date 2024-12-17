import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty_app/Data/firebase/services/user_firestore_service.dart';
import 'package:hedieaty_app/Models/user_model.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserFirestoreService _userFirestoreService = UserFirestoreService();
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      String uid = userCredential.user?.uid ?? "";
      // Create a User object and save it to Firestore
      UserModel newUser = UserModel(
        id: uid,
        name: name.trim(),
        email: email.trim(),
        phoneNumber: phone.trim(),
      );
      await _userFirestoreService.addUser(newUser);
      // Update the displayName //No need anymore
      //await userCredential.user?.updateDisplayName(name);
      //await userCredential.user?.reload(); // Refresh the user data

      //print('User registered: ${userCredential.user?.displayName}');
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }

  }
  // Login function
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Perform login
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Fetch the user data using the UID
      final String uid = userCredential.user?.uid ?? "";
      final UserModel? user = await _userFirestoreService.getUserByUid(uid);

      if (user != null) {
        return user; // Return the user object if found
      } else {
        throw Exception("User document not found");
      }
      // Return the user object if login is successful
      //return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Throw the error message to be handled by the UI
      throw Exception(e.message ?? 'Login failed');
    }
  }
}
