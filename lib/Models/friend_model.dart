import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id; // Firestore document ID
  final String fromId; // ID of the user who sent the request
  final String toId; // ID of the user receiving the request
  final String fromName; // Name of the sender
  final String toName; // Name of the receiver
  final String status; // "pending", "accepted", or "blocked"
  final Timestamp createdAt; // Timestamp of creation

  Friend({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.fromName,
    required this.toName,
    required this.status,
    required this.createdAt,
  });

  // Factory to create Friend object from Firestore DocumentSnapshot
  factory Friend.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Friend(
      id: doc.id,
      fromId: data['fromId'] ?? '',
      toId: data['toId'] ?? '',
      fromName: data['fromName'] ?? 'Unknown',
      toName: data['toName'] ?? 'Unknown',
      status: data['status'] ?? 'unknown',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert Friend object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'fromId': fromId,
      'toId': toId,
      'fromName': fromName,
      'toName': toName,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
