  import 'package:cloud_firestore/cloud_firestore.dart';
  
  class Friend {
    final String id; // Firestore document ID
    final String userId; // ID of the user who added the friend
    final String friendId; // ID of the friend being added
    final String name; // Friend's name
    final String status; // "pending", "accepted", or "blocked"
    final Timestamp createdAt; // Timestamp of creation

    Friend({
      required this.id,
      required this.userId,
      required this.friendId,
      required this.name, // Add name to the model
      required this.status,
      required this.createdAt,
    });
  
    // Factory to create Friend object from Firestore DocumentSnapshot
    factory Friend.fromFirestore(DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Friend(
        id: doc.id,
        userId: data['userId'] ?? 'nothing', // Check for null and provide a fallback
        friendId: data['friendId'] ?? 'nothing',
        name: data['name'] ?? 'nothing',
        status: data['status'] ?? 'nothing',
        createdAt: data['createdAt'] ?? Timestamp.now(),
      );
    }
  
    // Convert Friend object to Firestore format
    Map<String, dynamic> toFirestore() {
      return {
        'userId': userId,
        'friendId': friendId,
        'name': name, // Include name in Firestore format
        'status': status,
        'createdAt': createdAt,
      };
    }
  }
