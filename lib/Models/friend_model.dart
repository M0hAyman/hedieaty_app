import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id; // Firestore document ID
  final String userId; // ID of the user who added the friend
  final String friendId; // ID of the friend being added
  final String status; // "pending", "accepted", or "blocked"
  final Timestamp createdAt; // Timestamp of creation

  Friend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status, // pending, accepted, blocked
    required this.createdAt,
  });

  // Factory to create Friend object from Firestore DocumentSnapshot
  factory Friend.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Friend(
      id: doc.id,
      userId: data['userId'],
      friendId: data['friendId'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }

  // Convert Friend object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'friendId': friendId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
