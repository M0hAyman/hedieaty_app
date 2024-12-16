class User {
  final String id;   //Maybe Firebase UID
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

  // Convert SQFlite data to User object
  factory User.fromSQFlite(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      preference: data['preference'],
    );
  }

  // Convert User object to SQFlite data
  Map<String, dynamic> toSQFlite() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'preference': preference,
    };
  }
}

