class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String preference;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.preference,
  });

  // Convert Firestore data to User object
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      preference: data['preference'],
    );
  }

  // Convert User object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'preference': preference,
    };
  }
}
