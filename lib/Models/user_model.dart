class UserModel {     // class name changed as the name User was conflicting with the User class from Firebase Auth
  final String id;   //Firebase UID
  final String name;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  // Convert Firestore data to User object
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  // Convert User object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'id': id, // changed 'id' to 'uid' to match the Firestore document field
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }


}

